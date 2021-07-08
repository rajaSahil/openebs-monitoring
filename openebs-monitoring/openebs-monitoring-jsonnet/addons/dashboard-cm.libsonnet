local dashboards = (import 'github.com/rajaSahil/openebs-mixin/mixin.libsonnet').grafanaDashboards;
local utils = import '../lib/utils.libsonnet';
local config = import '../../config.libsonnet';


{
  grafanaDashboards: {

    [if config._config.casType[casType].enabled && config._config.casType[casType].installDashboards then name]:

      utils.ConfigMap('grafana-dashboard-' + std.asciiLower(std.strReplace(name, '.json', ''))) {
        data: { [name]: std.manifestJson(dashboards[casType][name]) },

      }

    for casType in std.objectFields(config._config.casType)
    for name in std.objectFields(dashboards[casType])
  },
}
