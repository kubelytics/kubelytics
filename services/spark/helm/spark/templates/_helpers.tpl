{{/* vim: set filetype=mustache: */}}

{{/*
Create fully qualified names.
*/}}

{{- define "spark.master-name" -}}
{{- printf "%s-master" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "spark.webui-name" -}}
{{- printf "%s-webui" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "spark.worker-name" -}}
{{- printf "%s-worker" .Release.Name | trunc 63 -}}
{{- end -}}

{{- define "spark.zeppelin-name" -}}
{{- printf "%s-zeppelin" .Release.Name | trunc 63 -}}
{{- end -}}
