export function createSuccessResponse(data = {}) {
  return {
    success: true,
    ...data
  }
}

export function createErrorResponse(message, code = null) {
  return {
    success: false,
    message,
    ...(code && { code })
  }
}

export function createValidationResponse(isValid, data = {}) {
  return {
    success: isValid,
    hasAccess: isValid,
    ...data
  }
}

export function createTokenResponse(valid, reason = null, retry = false, newToken = null) {
  return {
    valid,
    ...(reason && { reason }),
    ...(retry && { retry, newToken })
  }
}

export function createStageResponse(stage, nextStage, hasAccess = false, finalScript = null) {
  return {
    success: true,
    stage,
    ...(hasAccess && { hasAccess, finalScript }),
    ...(!hasAccess && { nextStage })
  }
}

export function createAccessResponse(hasAccess, timeRemaining = null, expiresAt = null, registrationTime = null) {
  return {
    success: hasAccess,
    hasAccess,
    ...(timeRemaining !== null && { timeRemaining }),
    ...(expiresAt && { expiresAt }),
    ...(registrationTime && { registrationTime })
  }
}
