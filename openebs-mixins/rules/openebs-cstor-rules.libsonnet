{
  prometheusRules+:: {
    cStor: {
      groups+: [
        {
          name: 'openebs-cStor-pool',
          rules: [
            {
              alert: 'PoolCapacityLow',
              annotations: {
                componentType: 'pool',
                cstorPool: '{{ $labels.cstor_pool }}',
                storageClassClaim: '{{ $labels.storage_pool_claim }}',
                description: 'OpenEBS Pool {{ $labels.cstor_pool }} use more than 80% of his capacity',
                summary: "cStor pool '{{$labels.cstor_pool}}' created for pool claim '{{$labels.storage_pool_claim}}' has {{ with printf \"openebs_free_pool_capacity{cstor_pool='%s',instance='%s',job='%s',kubernetes_pod_name='%s',slave='%s',storage_pool_claim='%s'}/(1024*1024*1024)\" $labels.cstor_pool $labels.instance $labels.job $labels.kubernetes_pod_name $labels.slave $labels.storage_pool_claim | query }} {{ . | first | value }} {{ end }}GB space remaining out of {{ with printf \"openebs_pool_size{cstor_pool='%s',instance='%s',job='%s',kubernetes_pod_name='%s',slave='%s',storage_pool_claim='%s'}/(1024*1024*1024)\" $labels.cstor_pool $labels.instance $labels.job $labels.kubernetes_pod_name $labels.slave $labels.storage_pool_claim | query }} {{ . | first | value }} {{ end }} GB. You have already consumed {{ $value }} percent of total capacity",
              },
              expr: 'openebs_used_pool_capacity_percent > 80',
              'for': '2m',
              labels: {
                severity: 'warning',
              },
            },
          ],
        },
        {
          name: 'openebs-cStor-volume',
          rules: [
            {
              alert: 'VolumeCapacityLow',
              annotations: {
                componentType: 'volume',
                openebsVolume: '{{ $labels.openebs_pv }}',
                openebsVolumeClaim: '{{ $labels.openebs_pvc }}',
                description: "OpenEBS volume '{{$labels.openebs_pv}}' created for '{{$labels.openebs_pvc}}' is running low on capacity, you have already consumed {{ $value }}% of total capacity",
                summary: "OpenEBS volume '{{$labels.openebs_pv}}' created for '{{$labels.openebs_pvc}}' has {{ with printf \"openebs_size_of_volume{openebs_pv='%s',instance='%s',job='%s',kubernetes_pod_name='%s',openebs_pvc='%s'}-openebs_actual_used{openebs_pv='%s',instance='%s',job='%s',kubernetes_pod_name='%s',openebs_pvc='%s'}\" $labels.openebs_pv $labels.instance $labels.job $labels.kubernetes_pod_name $labels.openebs_pvc $labels.openebs_pv $labels.instance $labels.job $labels.kubernetes_pod_name $labels.openebs_pvc | query }} {{ . | first | value }} {{ end }}GB) space remaining.",
              },
              expr: '((openebs_actual_used{openebs_cstor_label="cstor-volume-manager"}/openebs_size_of_volume{openebs_cstor_label="cstor-volume-manager"})*100 > 90)',
              'for': '2m',
              labels: {
                severity: 'warning',
              },
            },
          ],
        },
      ],
    },
  },
}
