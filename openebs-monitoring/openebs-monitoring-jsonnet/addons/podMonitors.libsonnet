local oc= import '../lib/utils.libsonnet';
local config=import '../../config.libsonnet';

{
   podMonitors: 
   {
		[if config._config.casType[casType].enabled && config._config.casType[casType].podMonitor.enabled then casType]:
			oc.PodMonitor(std.asciiLower(casType),casType)
		for casType in std.objectFields(config._config.casType)
	},
}