{{/*
Common labels for all resources.
*/}}
{{- define "flex.labels" -}}
helm.sh/chart: {{ include "flex.chart" . }}
{{ include "flex.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.global.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels - these must NOT change after deployment.
*/}}
{{- define "flex.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flex.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels including selector labels and custom pod labels.
*/}}
{{- define "flex.podLabels" -}}
{{ include "flex.selectorLabels" . }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Common annotations for all resources.
*/}}
{{- define "flex.annotations" -}}
{{- with .Values.global.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Pod annotations.
*/}}
{{- define "flex.podAnnotations" -}}
{{- with .Values.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Labels for a specific resource with optional extra labels.
Usage: {{ include "flex.resourceLabels" (dict "context" . "labels" .Values.service.labels) }}
*/}}
{{- define "flex.resourceLabels" -}}
{{- include "flex.labels" .context }}
{{- with .labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Annotations for a specific resource with optional extra annotations.
Usage: {{ include "flex.resourceAnnotations" (dict "context" . "annotations" .Values.service.annotations) }}
*/}}
{{- define "flex.resourceAnnotations" -}}
{{- $commonAnnotations := include "flex.annotations" .context | fromYaml }}
{{- $resourceAnnotations := .annotations | default dict }}
{{- $merged := merge $resourceAnnotations $commonAnnotations }}
{{- if $merged }}
{{ toYaml $merged }}
{{- end }}
{{- end }}
