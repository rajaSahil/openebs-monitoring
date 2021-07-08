local dashboards = (import '../mixin.libsonnet').grafanaDashboards;
local config = import '../config.libsonnet';

{
  [if config._config.dashboards[casType] then name]: dashboards[casType][name]
  for casType in std.objectFields(config._config.dashboards)
  for name in std.objectFields(dashboards[casType])
}
