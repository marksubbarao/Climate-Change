// Fragment shader for  Markers. A passed value (markerType) determines the type of marker drawn
uniform float uv_fade;
uniform float markerType;
uniform float displayMode;
uniform float uv_simulationtimeSeconds;
in vec2 texcoord;
in vec4 color;
in float phase;
out vec4 fragColor;

void main()
{
    float omega=3.0*6.28;
    vec2 fromCenter = texcoord * 2 - vec2(1);
	float dist2=dot(fromCenter,fromCenter);
	int pMarker =int(markerType); 
	fragColor = color;
	fragColor.a*=uv_fade*(1.0-smoothstep(0.8,1.0,texcoord[0]));
	//make arrow head
    if (texcoord[0]<0.1){
	  if (abs(2.0*texcoord[1]-1)>10.*texcoord[0]){
	    discard;
	  }
	}
	else { //make arrow body
	  if (abs(texcoord[1]-0.35*smoothstep(0.1,0.3,texcoord[0])*sin((texcoord[0]-0.1)*omega-phase)-0.5)>.15){
	    discard;
	  }
	}
}
