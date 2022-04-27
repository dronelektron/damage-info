float Math_CalculateDistance(int victim, int attacker) {
    float victimPos[VECTOR_SIZE];
    float attackerPos[VECTOR_SIZE];

    GetClientAbsOrigin(victim, victimPos);
    GetClientAbsOrigin(attacker, attackerPos);

    return GetVectorDistance(victimPos, attackerPos, SQUARED_NO) * METERS_PER_UNIT;
}

int Math_Max(int a, int b) {
    return a > b ? a : b;
}
