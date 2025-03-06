import common from '@ohos.app.ability.common'

export function resourceToStr(context: common.UIAbilityContext, source: Resource): string {
  return context.resourceManager.getStringSync(source)
}

