# Generic Charts

A collection of generic, fully customizable Helm charts for deploying any workload type on Kubernetes.

## Repository Structure

```
generic-charts/
├── charts/
│   └── generic/          # Main Helm chart
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       ├── examples/
│       └── tests/
└── .github/workflows/    # CI/CD workflows
```

## Installation

### Add the Helm Repository

```bash
helm repo add generic-charts https://foushua.github.io/generic-charts
helm repo update
```

### Install a Chart

```bash
helm install my-release generic-charts/generic -f values.yaml
```

### Alternative: OCI Registry

```bash
helm install my-release oci://ghcr.io/foushua/charts/generic --version 1.0.0
```

## Charts

| Chart | Description |
|-------|-------------|
| [generic](./charts/generic/) | A super generic, fully customizable Helm chart for deploying Deployments, StatefulSets, DaemonSets, Jobs, and CronJobs |

## Documentation

See the [chart README](./charts/generic/README.md) for detailed configuration options and examples.

## License

MIT
