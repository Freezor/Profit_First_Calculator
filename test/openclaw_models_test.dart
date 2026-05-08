import 'dart:convert';
import 'dart:io';

import 'package:profit_first_calculator/openclaw.dart';
import 'package:test/test.dart';

Map<String, dynamic> fixture(String name) {
  final contents = File('fixtures/openclaw/$name.json').readAsStringSync();
  return jsonDecode(contents) as Map<String, dynamic>;
}

void main() {
  group('OpenClawInstance', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('openclaw_instance');
      final instance = OpenClawInstance.fromJson(json);

      expect(instance.baseUrl, Uri.parse('https://openclaw.example.com/api'));
      expect(instance.capabilities.commands, isTrue);
      expect(instance.toJson(), json);
    });

    test('tryFromJson returns failure for structurally invalid payloads', () {
      final result = OpenClawInstance.tryFromJson(<String, dynamic>{
        'baseUrl': 42,
        'instanceName': 'Broken',
        'version': '0.0.0',
        'capabilities': <String, dynamic>{},
      });

      expect(result.isFailure, isTrue);
      expect(result.fold((_) => null, (error) => error.modelName), 'OpenClawInstance');
    });
  });

  group('OpenClawCapabilities', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('openclaw_capabilities');
      final capabilities = OpenClawCapabilities.fromJson(json);

      expect(capabilities.approvals, isFalse);
      expect(capabilities.toJson(), json);
    });
  });

  group('AgentRun', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('agent_run');
      final run = AgentRun.fromJson(json);

      expect(run.lifecycleState, RunLifecycleState.running);
      expect(run.attentionState, RunAttentionState.needsAttention);
      expect(run.openInSourceUrl, Uri.parse('https://github.com/example/project/pull/42'));
      expect(run.toJson(), json);
    });

    test('falls back to unknown for new lifecycle and attention enum values', () {
      final json = fixture('agent_run')
        ..['lifecycleState'] = 'superseded'
        ..['attentionState'] = 'escalated';

      final run = AgentRun.fromJson(json);

      expect(run.lifecycleState, RunLifecycleState.unknown);
      expect(run.attentionState, RunAttentionState.unknown);
      expect(run.toJson()['lifecycleState'], 'unknown');
      expect(run.toJson()['attentionState'], 'unknown');
    });

    test('uses false as the default pinned state', () {
      final json = fixture('agent_run')..remove('isPinned');
      final run = AgentRun.fromJson(json);

      expect(run.isPinned, isFalse);
    });
  });

  group('AttentionItem', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('attention_item');
      final item = AttentionItem.fromJson(json);

      expect(item.type, AttentionType.approval);
      expect(item.riskLevel, RiskLevel.high);
      expect(item.status, AttentionItemStatus.open);
      expect(item.availableActions, contains('approve'));
      expect(item.toJson(), json);
    });

    test('falls back to unknown for new attention enum values', () {
      final json = fixture('attention_item')
        ..['type'] = 'policy_exception'
        ..['riskLevel'] = 'severe'
        ..['status'] = 'snoozed';

      final item = AttentionItem.fromJson(json);

      expect(item.type, AttentionType.unknown);
      expect(item.riskLevel, RiskLevel.unknown);
      expect(item.status, AttentionItemStatus.unknown);
    });
  });

  group('RunEvent', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('run_event');
      final event = RunEvent.fromJson(json);

      expect(event.severity, EventSeverity.info);
      expect(event.details?['toolName'], 'write_file');
      expect(event.toJson(), json);
    });

    test('falls back to unknown for new severity values', () {
      final json = fixture('run_event')..['severity'] = 'notice';
      final event = RunEvent.fromJson(json);

      expect(event.severity, EventSeverity.unknown);
    });
  });

  group('SteeringCommand', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('steering_command');
      final command = SteeringCommand.fromJson(json);

      expect(command.type, SteeringCommandType.message);
      expect(command.toJson(), json);
    });

    test('falls back to unknown for new command values', () {
      final command = SteeringCommand.fromJson(<String, dynamic>{
        'type': 'delegate',
        'text': 'Hand this to another agent.',
      });

      expect(command.type, SteeringCommandType.unknown);
    });
  });

  group('CommandResult', () {
    test('deserializes and serializes valid payloads', () {
      final json = fixture('command_result');
      final result = CommandResult.fromJson(json);

      expect(result.state, CommandResultState.accepted);
      expect(result.toJson(), json);
    });

    test('tryFromJson returns success for valid payloads and unknown for new states', () {
      final result = CommandResult.tryFromJson(<String, dynamic>{
        'state': 'deferred',
        'summary': 'The server deferred processing.',
      });

      expect(result.isSuccess, isTrue);
      expect(
        result.fold((value) => value.state, (_) => CommandResultState.failed),
        CommandResultState.unknown,
      );
    });
  });
}
