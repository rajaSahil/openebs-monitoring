local config = import '../config.libsonnet';
local d= (import '../dashboards/d.libsonnet').grafanaDashboards;
{
	[name]: name
  	for name in std.objectFields(d)
}