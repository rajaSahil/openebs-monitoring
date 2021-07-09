local config = import '../config.libsonnet';
local d= (import 'dashboards.libsonnet').grafanaDashboards;

{
  grafanaDashboards+:: {
	[name]: d[name]
	for casType in std.objectFields(config._config.dashboards)
	for name in std.objectFields(d[casType])
  },
}
