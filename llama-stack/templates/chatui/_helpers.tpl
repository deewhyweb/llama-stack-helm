{{/*
Expand the name of the chart.
*/}}
{{- define "llama-stack-chatui.name" -}}
{{- printf "%s-%s" (default .Chart.Name .Values.nameOverride | trunc 51  | trimSuffix "-") "chatui" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "llama-stack-chatui.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- print (default .Chart.Name .Values.fullNameOverride | trunc 51  | trimSuffix "-") "-chatui" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- print (.Release.Name | trunc 51  | trimSuffix "-") "-chatui" }}
{{- else }}
{{- print (printf "%s-%s" .Release.Name $name | trunc 51 | trimSuffix "-") "-chatui" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
chatui Selector labels
*/}}
{{- define "llama-stack-chatui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llama-stack-chatui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

