{
  _config+:: {
    openebsMonitoring: {
      namespace: 'openebs-monitoring',
    },
    casType:{
      cStor:{
        enabled:true,
        installDashboards:true,
        alertRules: false,
        serviceMonitor:{
          enabled:true,
          endpoints: {

            port: 'exporter',
            //# HTTP path to scrape for metrics
            //  path: /metrics
            path: '/metrics',
            relabelings:[{
              sourceLabels: ["__meta_kubernetes_pod_label_monitoring"],
              regex: 'volume_exporter_prometheus',
              action: 'keep',
            },
            {
              sourceLabels: ["__meta_kubernetes_pod_label_vsm"],
              targetLabel: 'openebs_pv',
              action: 'replace',
            },
            {
              sourceLabels: ["__meta_kubernetes_pod_label_openebs_io_persistent_volume"],
              targetLabel: 'openebs_pv',
              action: 'replace',
            },
            {
              sourceLabels: ["__meta_kubernetes_pod_label_openebs_io_persistent_volume_claim"],
              targetLabel: 'openebs_pvc',
              action: 'replace',
            },
            {
              sourceLabels: ["__meta_kubernetes_pod_label_app"],
              targetLabel: 'openebs_cstor_label',
              action: 'replace',
            },
            ]
          },
          selector: {
            matchLabels:{
            'openebs.io/cas-type': "cstor",
            },
          },
          namespaceSelector:{
              any:true,
          },
        },
        podMonitor:{
          enabled:true,
          podMetricsEndpoints:{
            targetPort: 9500,

            ## HTTP path to scrape for metrics
            #     path: /metrics
            path: "/metrics",
            relabelings:[{
                sourceLabels: ["__meta_kubernetes_pod_label_monitoring"],
                regex: 'pool_exporter_prometheus',
                action: 'keep',
              },
              {
                sourceLabels: ["__meta_kubernetes_pod_label_vsm"],
                targetLabel: 'openebs_pv',
                action: 'replace',
              },
              {
                sourceLabels: [
              "__meta_kubernetes_pod_label_openebs_io_storage_pool_claim",
              "__meta_kubernetes_pod_label_openebs_io_cstor_pool_cluster",],
                separator: "",
                targetLabel: 'storage_pool_claim',
                action: 'replace',
              },
              {
                sourceLabels:  ["__meta_kubernetes_pod_label_openebs_io_cstor_pool","__meta_kubernetes_pod_label_openebs_io_cstor_pool_instance",],
                separator: "",
                targetLabel: 'cstor_pool',
                action: 'replace',
              },
              {
                sourceLabels: ["__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port"],
                action: 'replace',
                #regex: '([^:]+)(?::\d+)?;(\d+)',
                replacement: '${1}:${2}',
                targetLabel: '__address__',
              },
            ]
          },
          selector: {
            matchLabels:{
            'app': "cstor-pool",
            },
          },
          namespaceSelector:{
              any:true,
          },
        },
      },
      Jiva:{
        enabled:true,
        installDashboards:true,
        alertRules: true,
        serviceMonitor:{
          enabled:true,
          endpoints: {

            port: 'metrics',

            //# HTTP path to scrape for metrics
            //  path: /metrics
            path: '/metrics',
            relabelings:[{
                sourceLabels: ["__meta_kubernetes_pod_label_monitoring"],
                regex: 'volume_exporter_prometheus',
                action: 'keep',
              },
              {
                sourceLabels: ["__meta_kubernetes_pod_label_vsm"],
                targetLabel: 'openebs_pv',
                action: 'replace',
              },
              {
                sourceLabels: ["__meta_kubernetes_pod_label_openebs_io_persistent_volume"],
                targetLabel: 'openebs_pv',
                action: 'replace',
              },
              {
                sourceLabels: ["__meta_kubernetes_pod_label_openebs_io_persistent_volume_claim"],
                targetLabel: 'openebs_pvc',
                action: 'replace',
              },
              {
                sourceLabels: ["__meta_kubernetes_pod_label_app"],
                targetLabel: 'openebs_jiva_label',
                action: 'replace',
              },
            ]
          },
          selector: {
            matchLabels:{
              'openebs.io/cas-type': "jiva",
            },
          },
          namespaceSelector:{
              any:true,
          },
        },
        podMonitor:{
          enabled:false,
        },
      },
      LocalPV: {
        enabled: true,
        installDashboards:true,
        alertRules: false,
        serviceMonitor:{
          enabled:true,
          endpoints: {

            port: 'metrics',

            //# HTTP path to scrape for metrics
            //  path: /metrics
            path: '/metrics',
          },
          selector: {
            matchLabels:{
              'name': "lvm-node",
            },
          },
          namespaceSelector:{
              any: true,
          },
        },
        podMonitor:{
          enabled:false,
        },
      },
    },
    
  },
}
