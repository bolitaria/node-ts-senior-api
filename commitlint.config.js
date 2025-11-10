module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // Nueva característica
        'fix',      // Corrección de bug
        'docs',     // Documentación
        'style',    // Cambios de formato
        'refactor', // Refactorización
        'test',     // Tests
        'chore',    // Tareas de mantenimiento
        'perf',     // Mejora de rendimiento
        'ci',       // CI/CD
        'revert',   // Revertir cambios
        'wip'       // Trabajo en progreso
      ]
    ],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
    'scope-case': [2, 'always', 'lower-case'],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 100]
  }
};