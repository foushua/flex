{{/*
Expand the name of the chart.
*/}}
{{- define "generic.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "generic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Determine the namespace to use.
*/}}
{{- define "generic.namespace" -}}
{{- if .Values.global.namespace }}
{{- .Values.global.namespace }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "generic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "generic.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build full image reference.
Usage: {{ include "generic.image" (dict "image" .Values.containers.main.image "global" .Values.global "Chart" .Chart) }}
*/}}
{{- define "generic.image" -}}
{{- $registry := .image.registry | default .global.imageRegistry | default "" -}}
{{- $repository := .image.repository | default "" -}}
{{- $tag := .image.tag | default .Chart.AppVersion | default "latest" -}}
{{- $digest := .image.digest | default "" -}}
{{- if $digest }}
{{- if $registry }}
{{- printf "%s/%s@%s" $registry $repository $digest }}
{{- else }}
{{- printf "%s@%s" $repository $digest }}
{{- end }}
{{- else }}
{{- if $registry }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- else }}
{{- printf "%s:%s" $repository $tag }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Merge global and local image pull secrets.
*/}}
{{- define "generic.imagePullSecrets" -}}
{{- $secrets := list }}
{{- if .Values.global.imagePullSecrets }}
{{- range .Values.global.imagePullSecrets }}
{{- $secrets = append $secrets . }}
{{- end }}
{{- end }}
{{- if .Values.imagePullSecrets }}
{{- range .Values.imagePullSecrets }}
{{- $secrets = append $secrets . }}
{{- end }}
{{- end }}
{{- if .Values.serviceAccount.imagePullSecrets }}
{{- range .Values.serviceAccount.imagePullSecrets }}
{{- $secrets = append $secrets (dict "name" .) }}
{{- end }}
{{- end }}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets | uniq }}
  - name: {{ .name | default . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate container name from key or explicit name.
*/}}
{{- define "generic.containerName" -}}
{{- $name := .name | default .key -}}
{{- if eq $name "main" }}
{{- include "generic.name" .context }}
{{- else }}
{{- $name }}
{{- end }}
{{- end }}

{{/*
StatefulSet service name.
*/}}
{{- define "generic.statefulset.serviceName" -}}
{{- if .Values.workload.statefulset.serviceName }}
{{- .Values.workload.statefulset.serviceName }}
{{- else }}
{{- include "generic.fullname" . }}-headless
{{- end }}
{{- end }}
