local prometheusRules= (import 'github.com/rajaSahil/openebs-mixin/mixin.libsonnet').prometheusRules;
local utils= import '../lib/utils.libsonnet';
local config=import '../../config.libsonnet';

{
   prometheusRules: 
   {
		[if config._config.casType[casType].enabled && config._config.casType[casType].alertRules   then casType]:
			 
			utils.PrometheusRule(std.asciiLower(casType)){
				spec+:{
					groups:prometheusRules[casType].groups,
				},
			},
		
		for casType in std.objectFields(config._config.casType)
	},
}