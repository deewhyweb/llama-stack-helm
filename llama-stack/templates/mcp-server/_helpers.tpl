{{/*
Expand the name of the chart.
*/}}
{{- define "mcp-server.name" -}}
{{- printf "%s-%s" (default .Chart.Name .Values.nameOverride | trunc 51  | trimSuffix "-") "mcp" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mcp-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- print (default .Chart.Name .Values.fullNameOverride | trunc 51  | trimSuffix "-") "-mcp" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- print (.Release.Name | trunc 51  | trimSuffix "-") "-mcp" }}
{{- else }}
{{- print (printf "%s-%s" .Release.Name $name | trunc 51 | trimSuffix "-") "-mcp" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mcp-server.labels" -}}
helm.sh/chart: {{ include "llama-stack.chart" . }}
{{ include "mcp-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
mcp Selector labels
*/}}
{{- define "mcp-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mcp-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
