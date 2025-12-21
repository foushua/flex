{{/*
Pod template spec - shared by all workload types.
*/}}
{{- define "generic.podSpec" -}}
{{- include "generic.imagePullSecrets" . }}
{{- if .Values.serviceAccount.create }}
serviceAccountName: {{ include "generic.serviceAccountName" . }}
{{- else if .Values.serviceAccount.name }}
serviceAccountName: {{ .Values.serviceAccount.name }}
{{- end }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ .Values.terminationGracePeriodSeconds }}
{{- end }}
{{- if .Values.dnsPolicy }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- end }}
{{- with .Values.dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.hostNetwork }}
hostNetwork: {{ .Values.hostNetwork }}
{{- end }}
{{- if .Values.hostPID }}
hostPID: {{ .Values.hostPID }}
{{- end }}
{{- if .Values.hostIPC }}
hostIPC: {{ .Values.hostIPC }}
{{- end }}
{{- if .Values.shareProcessNamespace }}
shareProcessNamespace: {{ .Values.shareProcessNamespace }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
{{- if .Values.runtimeClassName }}
runtimeClassName: {{ .Values.runtimeClassName }}
{{- end }}
{{- if .Values.schedulerName }}
schedulerName: {{ .Values.schedulerName }}
{{- end }}
{{- if .Values.initContainers }}
initContainers:
  {{- range $name, $container := .Values.initContainers }}
  - name: {{ $name }}
    image: {{ include "generic.image" (dict "image" $container.image "global" $.Values.global "Chart" $.Chart) }}
    imagePullPolicy: {{ $container.image.pullPolicy | default "IfNotPresent" }}
    {{- with $container.command }}
    command:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.args }}
    args:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.env }}
    env:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.envFrom }}
    envFrom:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.volumeMounts }}
    volumeMounts:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
{{- end }}
containers:
  {{/* Main container */}}
  - name: {{ .Values.container.name | default (include "generic.name" .) }}
    image: {{ include "generic.image" (dict "image" .Values.container.image "global" .Values.global "Chart" .Chart) }}
    imagePullPolicy: {{ .Values.container.image.pullPolicy | default "IfNotPresent" }}
    {{- with .Values.container.command }}
    command:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.args }}
    args:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.ports }}
    ports:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.env }}
    env:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.envFrom }}
    envFrom:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if .Values.container.livenessProbe.enabled }}
    livenessProbe:
      {{- $probe := omit .Values.container.livenessProbe "enabled" }}
      {{- toYaml $probe | nindent 6 }}
    {{- end }}
    {{- if .Values.container.readinessProbe.enabled }}
    readinessProbe:
      {{- $probe := omit .Values.container.readinessProbe "enabled" }}
      {{- toYaml $probe | nindent 6 }}
    {{- end }}
    {{- if .Values.container.startupProbe.enabled }}
    startupProbe:
      {{- $probe := omit .Values.container.startupProbe "enabled" }}
      {{- toYaml $probe | nindent 6 }}
    {{- end }}
    {{- with .Values.container.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.volumeMounts }}
    volumeMounts:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{/* Sidecars */}}
  {{- range $name, $container := .Values.sidecars }}
  - name: {{ $name }}
    image: {{ include "generic.image" (dict "image" $container.image "global" $.Values.global "Chart" $.Chart) }}
    imagePullPolicy: {{ $container.image.pullPolicy | default "IfNotPresent" }}
    {{- with $container.command }}
    command:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.args }}
    args:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.ports }}
    ports:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.env }}
    env:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.envFrom }}
    envFrom:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if $container.livenessProbe }}
    {{- if $container.livenessProbe.enabled }}
    livenessProbe:
      {{- $probe := omit $container.livenessProbe "enabled" }}
      {{- toYaml $probe | nindent 6 }}
    {{- end }}
    {{- end }}
    {{- if $container.readinessProbe }}
    {{- if $container.readinessProbe.enabled }}
    readinessProbe:
      {{- $probe := omit $container.readinessProbe "enabled" }}
      {{- toYaml $probe | nindent 6 }}
    {{- end }}
    {{- end }}
    {{- with $container.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.volumeMounts }}
    volumeMounts:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $container.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
  {{- end }}
{{- /* Volumes */ -}}
{{- $volumes := list }}
{{- /* Add persistence volume if enabled */ -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) }}
{{- if ne .Values.workload.type "statefulset" }}
{{- $volumes = append $volumes (dict "name" "data" "persistentVolumeClaim" (dict "claimName" (include "generic.fullname" .))) }}
{{- end }}
{{- else if .Values.persistence.existingClaim }}
{{- $volumes = append $volumes (dict "name" "data" "persistentVolumeClaim" (dict "claimName" .Values.persistence.existingClaim)) }}
{{- end }}
{{- /* Add extra persistence volumes */ -}}
{{- range $name, $pvc := .Values.extraPersistence }}
{{- if $pvc.enabled }}
{{- $volumes = append $volumes (dict "name" $name "persistentVolumeClaim" (dict "claimName" (printf "%s-%s" (include "generic.fullname" $) $name))) }}
{{- end }}
{{- end }}
{{- /* Add configMap volumes */ -}}
{{- range $name, $cm := .Values.configMaps }}
{{- if $cm.enabled }}
{{- $volumes = append $volumes (dict "name" (printf "configmap-%s" $name) "configMap" (dict "name" (printf "%s-%s" (include "generic.fullname" $) $name))) }}
{{- end }}
{{- end }}
{{- /* Add secret volumes */ -}}
{{- range $name, $secret := .Values.secrets }}
{{- if $secret.enabled }}
{{- $volumes = append $volumes (dict "name" (printf "secret-%s" $name) "secret" (dict "secretName" (printf "%s-%s" (include "generic.fullname" $) $name))) }}
{{- end }}
{{- end }}
{{- /* Add extra volumes */ -}}
{{- range .Values.volumes }}
{{- $volumes = append $volumes . }}
{{- end }}
{{- if $volumes }}
volumes:
  {{- toYaml $volumes | nindent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Pod metadata (labels and annotations).
*/}}
{{- define "generic.podMetadata" -}}
labels:
  {{- include "generic.podLabels" . | nindent 2 }}
{{- $annotations := include "generic.podAnnotations" . }}
{{- if $annotations }}
annotations:
  {{- $annotations | nindent 2 }}
{{- end }}
{{- end }}
