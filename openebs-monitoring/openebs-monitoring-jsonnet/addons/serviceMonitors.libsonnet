local oc= import '../lib/utils.libsonnet';
local config=import '../../config.libsonnet';

{
   serviceMonitors: 
   {
		[if config._config.casType[casType].enabled && config._config.casType[casType].serviceMonitor.enabled  then casType]:
			oc.ServiceMonitor(std.asciiLower(casType),casType)
		for casType in std.objectFields(config._config.casType)
	},
}