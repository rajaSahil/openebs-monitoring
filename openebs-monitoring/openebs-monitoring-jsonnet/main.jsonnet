local dashboard = import './addons/dashboard-cm.libsonnet';
local podMonitors = import './addons/podMonitors.libsonnet';
local rules = import './addons/prometheusRules.libsonnet';
local serviceMonitor = import './addons/serviceMonitors.libsonnet';
local config= import '../config.libsonnet';

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: config._config.openebsMonitoring.namespace,
      },
    },
  };

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +


{ ['openebs-monitoring/openebs-servicemonitor-' + casType]: serviceMonitor.serviceMonitors[casType] for casType in std.objectFields(serviceMonitor.serviceMonitors) } +
{ ['openebs-monitoring/openebs-podmonitor-' + casType]: podMonitors.podMonitors[casType] for casType in std.objectFields(podMonitors.podMonitors) } +
{ ['openebs-monitoring/openebs-dashboard-' + std.strReplace(casType, '.json', '')]: dashboard.grafanaDashboards[casType] for casType in std.objectFields(dashboard.grafanaDashboards) } +
{ ['openebs-monitoring/openebs-rule-' + name]: rules.prometheusRules[name] for name in std.objectFields(rules.prometheusRules) }
