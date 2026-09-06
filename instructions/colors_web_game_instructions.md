# Instrucciones de color para Snake web game

Usar estas reglas antes de disenar o codificar el juego. El objetivo visual es que el primer vistazo diga: "juegame". Debe sentirse arcade, energico, claro, moderno y facil de leer.

## Direccion visual

- Priorizar una estetica arcade neon: fondo oscuro, tablero limpio, serpiente brillante y comida/acento con alta atencion visual.
- Usar color como guia de accion: los colores mas intensos deben indicar jugar, comer, ganar puntos, peligro o reiniciar.
- Mantener una paleta corta: 1 color dominante, 1 acento principal y 3-4 colores de apoyo. Evitar saturar la pantalla con demasiados tonos.
- Los fondos y paneles grandes deben ser oscuros o de baja saturacion; reservar neones para botones, comida, score, power-ups, estados y feedback.
- El juego debe verse divertido, no corporativo ni apagado. Evitar paletas beige, marrones, grises planos, monocromas o demasiado serias.

## Paleta base recomendada

Usar esta paleta como punto de partida, ajustandola solo si mejora legibilidad o jugabilidad.

- Fondo principal: `#0B1026`
- Superficie del tablero: `#111827`
- Lineas de grid: `#243B53`
- Serpiente cuerpo: `#00F5A0`
- Serpiente cabeza/brillo: `#63FFDA`
- Comida, CTA y foco: `#FF2E63`
- Score, recompensa y logro: `#FFE45E`
- Bonus, combo o accion rapida: `#FF9A00`
- Texto principal: `#F8FAFC`
- Texto secundario: `#A7B0C0`
- Error o peligro critico: `#FF3B30`

## Psicologia aplicada

- Verde/mint comunica vida, crecimiento y energia: usarlo para la serpiente y progreso positivo.
- Azul/cian comunica claridad, confianza y tecnologia: usarlo para base visual, grid y elementos de apoyo.
- Amarillo comunica optimismo, recompensa y logro: usarlo en score, records, monedas o celebraciones.
- Naranja comunica accion, aventura y creatividad: usarlo en bonus, combos o estados temporales.
- Rojo/pink comunica urgencia y atencion: usarlo con moderacion para comida, peligro, CTA o game over.
- Purpura/indigo comunica misterio, noche y estilo arcade: puede aparecer en sombras, fondos o glow sutil.
- Blanco sobre oscuro comunica precision y limpieza: usarlo para texto, numeros y mensajes esenciales.

## Reglas de diseno para el juego

- La serpiente debe ser el elemento movil mas reconocible; la comida debe ser el segundo punto mas llamativo.
- El tablero nunca debe competir con la serpiente: grid sutil, bajo contraste y sin decoracion innecesaria.
- Botones principales como Start, Retry o Play Again deben usar `#FF2E63` o `#FFE45E` sobre fondo oscuro.
- Los estados de hover, press y focus deben sentirse interactivos con brillo, borde o cambio de luminosidad, sin mover el layout.
- Usar contornos, sombras o glow de forma moderada para que el neon parezca luz de juego, no decoracion aleatoria.
- Repetir los mismos roles de color en titulo, HUD, tablero, pausa, game over y controles para crear identidad consistente.
- No depender solo del color para comunicar peligro, premio o estado: combinar color con forma, icono, patron, texto breve o animacion.
- Evitar contrastes problematicos para daltonismo: verde vs amarillo, amarillo vs rojo/naranja y purpura vs azul similar.
- Verificar contraste antes de finalizar: texto normal minimo 4.5:1; texto grande, iconos y bordes interactivos minimo 3:1.
- Probar siempre en desktop y mobile: ningun texto debe solaparse, ningun boton debe perder legibilidad y el tablero debe seguir siendo claro.

## Criterio de aceptacion visual

El diseno es correcto si, sin explicar nada, una persona puede identificar rapido donde jugar, donde esta la serpiente, que debe comer, cuanto puntaje lleva y cuando perdio. Debe sentirse intenso y jugueton, pero ordenado.
