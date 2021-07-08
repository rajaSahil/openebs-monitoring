local rules = (import '../mixin.libsonnet').prometheusRules;
local config = import '../config.libsonnet';

{
  [if config._config.alertRules[name] then name + '.yaml']: std.manifestYamlDoc(rules[name])
  for name in std.objectFields(config._config.alertRules)


}
