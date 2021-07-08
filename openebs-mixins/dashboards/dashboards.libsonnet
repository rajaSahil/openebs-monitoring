local config = import '../config.libsonnet';

{
  grafanaDashboards+:: {
    Jiva: {
      'jiva-volume.json': import 'jiva-volume.json',
    },
    cStor: {
      'cStor-overview.json': import 'cStor-overview.json',
      'cStor-volume.json': import 'cStor-volume.json',
      'cStor-volume-replica.json': import 'cStor-volume.json',
      'cStor-pool.json': import 'cStor-pool.json',
    },
    LocalPV: {
      'localpv-workload.json': import 'localpv-workload.json',
    },
  },
}
