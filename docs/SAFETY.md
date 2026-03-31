# Safety Model – Captain of Industry Mod Agent

## Core Principle: Deny-by-Default

The mod implements a strict **deny-by-default security model** where:
- ❌ All actions are BLOCKED by default
- ✅ Only explicitly whitelisted actions are allowed
- 🔒 No exceptions to the whitelist
- 📋 All decisions are logged for audit

## Action Categories

### 1. ReadOnly (Lowest Risk)
- **Purpose**: Query game state without modifications
- **Examples**: QueryGameState, GetResources, GetProductionChains
- **Risk Level**: 🟢 SAFE
- **Reversible**: Yes
- **Impact**: No game state changes

### 2. Diagnostics (Low Risk)
- **Purpose**: Logging and telemetry collection
- **Examples**: LogTelemetry, RecordMetrics, GenerateReport
- **Risk Level**: 🟢 SAFE
- **Reversible**: Yes (logs can be cleared)
- **Impact**: No game state changes

### 3. Advisory (Medium Risk)
- **Purpose**: Provide suggestions and scores (non-binding)
- **Examples**: ProvideAdvisoryScore, SuggestAction, EstimateOutcome
- **Risk Level**: 🟡 MEDIUM
- **Reversible**: Yes (suggestions are not executed)
- **Impact**: No game state changes, informational only

### 4. SafeModification (High Risk - Carefully Vetted)
- **Purpose**: Execute reversible game modifications
- **Examples**: ExecuteSafeAction, AdjustThresholds, PauseProduction
- **Risk Level**: 🔴 HIGH
- **Reversible**: Yes (can be undone)
- **Impact**: Temporary game state changes

### 5. Destructive (BLOCKED)
- **Purpose**: Permanent game state modifications
- **Examples**: DeleteStructure, SellResources, PermanentlyAllocate
- **Risk Level**: 🟣 FORBIDDEN
- **Reversible**: No (cannot be undone)
- **Impact**: Permanent changes - NOT ALLOWED

## Current Whitelist (4 Approved Actions)

```
✅ QueryGameState           [ReadOnly]         - No side effects
✅ LogTelemetry            [Diagnostics]      - Logging only
✅ ProvideAdvisoryScore    [Advisory]         - Suggestions only
✅ ExecuteSafeAction       [SafeModification] - Reversible changes

❌ BLOCKED: BuildStructure, DeleteStructure, AllocateResources, SellResources, etc.
```

## Audit Trail

Every action check is logged with:
- **Timestamp**: Exact time of decision
- **Action Name**: What was requested
- **Approved/Denied**: The decision
- **Reason**: Why it was approved or denied
- **Category**: Action category (if approved)

### Example Audit Log Entry
```
2026-03-31 17:30:45.123 | APPROVED | QueryGameState | Action is whitelisted [ReadOnly]
2026-03-31 17:30:46.456 | DENIED   | DeleteStructure | Action NOT in whitelist (DENY-BY-DEFAULT)
2026-03-31 17:30:47.789 | APPROVED | LogTelemetry | Action is whitelisted [Diagnostics]
```

## Safety Guarantees

### Guarantee 1: Strict Whitelist Enforcement
**Property**: No action can execute unless explicitly whitelisted.

**Implementation**:
```csharp
if (!_whitelist.ContainsKey(actionName))
    throw new UnauthorizedAccessException($"Action '{actionName}' blocked by deny-by-default policy");
```

**Test**: `DenyByDefault_AllUnknownActionsBlocked`

### Guarantee 2: Version Compatibility Checking
**Property**: Game version incompatibility is detected and warned about.

**Implementation**:
- Mod checks game version on load
- Warns if game version > supported version
- Blocks execution of version-sensitive actions if incompatible

**Test**: `GameVersionCompatibility_NewerVersion_ShowsWarning`

### Guarantee 3: Complete Audit Trail
**Property**: Every action decision is logged with full context.

**Implementation**:
```csharp
LogAuditEntry(actionName, approved, reason);
```

**Test**: `AuditLog_LogsApprovedAction`, `AuditLog_LogsDeniedAction`

### Guarantee 4: No Destructive Operations
**Property**: Actions that permanently modify game state are physically blocked.

**Implementation**:
- Destructive actions are not in whitelist enum
- No code path exists to execute them
- SafetyGuard throws exception before execution

**Test**: `IsWhitelisted_BuildStructure_ReturnsFalse`

### Guarantee 5: Reversibility Tracking
**Property**: All approved actions are marked as reversible (no permanent damage).

**Implementation**:
```csharp
public struct ActionWhitelistEntry
{
    public bool IsReversible { get; set; }  // Must be true for all approved actions
}
```

**Test**: `Whitelist_AllApprovedActionsAreReversible`

## Adding New Safe Actions

To add a new action to the whitelist:

1. **Identify Category**: Determine which category (ReadOnly, Diagnostics, Advisory, SafeModification)
2. **Verify Reversibility**: Ensure the action is reversible or has no game state impact
3. **Add to Whitelist**: Add entry to `_whitelist` dictionary
4. **Document**: Add description and add unit test
5. **Test**: Verify action works correctly with SafetyGuard

### Example: Adding QueryProduction
```csharp
_whitelist["QueryProduction"] = new ActionWhitelistEntry
{
    ActionName = "QueryProduction",
    Category = ActionCategory.ReadOnly,
    Description = "Query production chain status",
    IsReversible = true,
    AddedAt = DateTime.UtcNow
};
```

## Game Version Compatibility

The mod maintains a compatibility matrix:

| Mod Version | Game Version | Status | Notes |
|-------------|--------------|--------|-------|
| 0.1.0       | 1.0.0        | ✅ Tested | Initial release |
| 0.1.0       | 1.0.1        | ⚠️ Warning | Minor changes |
| 0.1.0       | 1.1.0        | ❌ Incompatible | Breaking changes |

When a new game version is detected:
- Mod warns user about potential incompatibility
- Non-critical features gracefully degrade
- Safe actions continue to work
- User can update mod or downgrade game

## Security Best Practices

1. **Never bypass the whitelist** - The deny-by-default policy is law
2. **Always log decisions** - Audit trail must be complete
3. **Test new actions** - Before adding to whitelist
4. **Document all actions** - Clear description of what each action does
5. **Mark reversibility** - Only truly safe, undoable actions approved
6. **Version check** - Always verify game compatibility

## Threat Model

This mod considers the following threats:

### Threat 1: Accidental Game State Corruption
**Mitigation**: Whitelist + reversibility check

### Threat 2: API Version Mismatch
**Mitigation**: Version checking + compatibility matrix

### Threat 3: Unintended Action Execution
**Mitigation**: Comprehensive audit logging

### Threat 4: RL Policy Misbehavior
**Mitigation**: Advisory-only RL output + SafetyGuard validation

### Threat 5: Vision Processing Errors
**Mitigation**: Read-only vision layer, no direct writes

---

**Last Updated**: 2026-03-31
**Safety Level**: 🔒 STRICT (Deny-by-Default)
**Audit Logging**: ✅ ENABLED
**Version Compatibility**: ✅ CHECKED