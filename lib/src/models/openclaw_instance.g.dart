// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openclaw_instance.dart';

OpenClawInstance _$OpenClawInstanceFromJson(Map<String, dynamic> json) =>
    OpenClawInstance(
      baseUrl: Uri.parse(json['baseUrl'] as String),
      instanceName: json['instanceName'] as String,
      version: json['version'] as String,
      capabilities: OpenClawCapabilities.fromJson(
        json['capabilities'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OpenClawInstanceToJson(OpenClawInstance instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl.toString(),
      'instanceName': instance.instanceName,
      'version': instance.version,
      'capabilities': instance.capabilities.toJson(),
    };
