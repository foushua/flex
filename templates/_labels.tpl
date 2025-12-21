{{/*
Common labels for all resources.
*/}}
{{- define "generic.labels" -}}
helm.sh/chart: {{ include "generic.chart" . }}
{{ include "generic.selectorLabels" . }}
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
{{- define "generic.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels including selector labels and custom pod labels.
*/}}
{{- define "generic.podLabels" -}}
{{ include "generic.selectorLabels" . }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Common annotations for all resources.
*/}}
{{- define "generic.annotations" -}}
{{- with .Values.global.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Pod annotations.
*/}}
{{- define "generic.podAnnotations" -}}
{{- with .Values.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Labels for a specific resource with optional extra labels.
Usage: {{ include "generic.resourceLabels" (dict "context" . "labels" .Values.service.labels) }}
*/}}
{{- define "generic.resourceLabels" -}}
{{- include "generic.labels" .context }}
{{- with .labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Annotations for a specific resource with optional extra annotations.
Usage: {{ include "generic.resourceAnnotations" (dict "context" . "annotations" .Values.service.annotations) }}
*/}}
{{- define "generic.resourceAnnotations" -}}
{{- $commonAnnotations := include "generic.annotations" .context | fromYaml }}
{{- $resourceAnnotations := .annotations | default dict }}
{{- $merged := merge $resourceAnnotations $commonAnnotations }}
{{- if $merged }}
{{ toYaml $merged }}
{{- end }}
{{- end }}
