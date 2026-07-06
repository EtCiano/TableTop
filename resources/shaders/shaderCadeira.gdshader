shader_type canvas_item;
uniform sampler2D texturaRuido : hint_default_white;
uniform bool ativarRuido = true;
uniform bool ativarVertex = true;
uniform bool animar = true;
uniform float suavidade : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float limite : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float velocidadeAndar : hint_range(0.0, 10.0, 0.1) = 0.1;
uniform vec4 corRuido : source_color = vec4(0.6, 0.5, 1.0, 1.0);
//uniform vec4 corMain : source_color = vec4(0.5, 0.4, 0.9, 1.0);
uniform float amplitude : hint_range(0.0, 100.0, 0.1) = 50.0;
uniform bool suave = false;
uniform float velocidadeOnda : hint_range(0.0, 10.0, 0.01) = 1.0;

void vertex() {
	if (ativarVertex) {
		VERTEX.y -= sin(TIME * velocidadeOnda) * ((1.0 - UV.y) * amplitude);
	}
}

void fragment() {
    vec4 corOriginal = texture(TEXTURE, UV);
	vec2 uvAnimada;
	
	if (animar) {
		uvAnimada = fract(UV + vec2(TIME * velocidadeAndar, TIME * velocidadeAndar * 0.5));
	} else {
		uvAnimada = fract(UV + vec2(velocidadeAndar, velocidadeAndar * 0.5));	
	}
	
    float ruido = texture(texturaRuido, uvAnimada).r;
	
	// responsável pela borda wobble
	if (corOriginal.a < ruido - limite * sin(TIME)) { 
        corOriginal = vec4(corOriginal.rgb, 0.5);
    } else {
        corOriginal = vec4(corOriginal.rgb, 1.0);
    }
	
	// responsavel pela corRuido
	if (ativarRuido) {
	    COLOR = vec4(corOriginal.rgb, corOriginal.a);
	}
}