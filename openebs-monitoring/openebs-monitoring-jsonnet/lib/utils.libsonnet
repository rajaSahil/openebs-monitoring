local config = import '../../config.libsonnet';
{


  _Object(apiVersion, kind, name):: {
    apiVersion: apiVersion,
    kind: kind,
    metadata: {
      name: name,
      labels: { name: name },
      annotations: {},
      //namespace:" $._config.namespace",
    },
  },
  ServiceMonitor(name, casType): $._Object('monitoring.coreos.com/v1', 'ServiceMonitor', name) {
    local svm = self,
    sc:: {
      st: config._config.casType,
    },
    spec: {
      //svm.sc.st[storageEngine],
      endpoints: [
        svm.sc.st[casType].serviceMonitor.endpoints,
      ],
      namespaceSelector: svm.sc.st[casType].serviceMonitor.namespaceSelector,
      selector: svm.sc.st[casType].serviceMonitor.selector,
    },
  },
  PodMonitor(name, casType): $._Object('monitoring.coreos.com/v1', 'PodMonitor', name) {
    local svm = self,
    sc:: {
      st: config._config.casType,
    },
    spec: {
      //svm.sc.st[storageEngine],
      podMetricsEndpoints: [
        svm.sc.st[casType].podMonitor.podMetricsEndpoints,
      ],
      namespaceSelector: svm.sc.st[casType].podMonitor.namespaceSelector,
      selector: svm.sc.st[casType].podMonitor.selector,
    },
  },
  ConfigMap(name): $._Object('v1', 'ConfigMap', name) {
    data: {},
  },
  PrometheusRule(name): $._Object('monitoring.coreos.com/v1', 'PrometheusRule', name) {
    spec: {

    },
  },
}
