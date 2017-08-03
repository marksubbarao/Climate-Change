in vec2 TexCoord;
uniform float uv_fade;
uniform float alpha;
uniform int uv_simulationtimeDays;
uniform sampler2D axes;
uniform sampler2D tempData;
out vec4 fragColor;

void main(void)
{
    vec4 yearColor;
	float years = uv_simulationtimeDays/365.25+1970.;
	//Using the GISS (J-D) measurment which is good from Jan 1 1880 to Dec 31 2016 
	//if (years<1880.0 || years>2017.0) discard;
	//draw axes
	if (TexCoord[1]>0.495 && TexCoord[1]<0.505) fragColor=vec4(1.0,1.0,0.0,1.0); 	
	if (TexCoord[0]>0.4975 && TexCoord[0]<0.5025) fragColor=vec4(1.0,1.0,0.0,1.0); 	
	float yearFrag = mix(1880.0,2017.0,TexCoord[0]);
	if (!gl_FrontFacing) yearFrag = mix(2017.0,1880.0,TexCoord[0]);
	if (yearFrag<years && mod(0.15+yearFrag-1880.0,1.0)>0.3) {
		float texVal= (yearFrag-1880.0)/137.0;
		yearColor=texture(tempData,vec2(texVal,0.5));
		float dT=2.56*(yearColor.r-0.5);
		float dTFrag=2.56*(TexCoord[1]-0.5);
		if (abs(dTFrag)<abs(dT)&& dT*dTFrag >0.) {
			if (yearColor.r<0.5) {
			  fragColor = vec4(0.0,1.0,1.0,1.0);
			} else {
			  fragColor = vec4(1.0,0.0,0.0,1.0);
			}
		}
    }
    vec4 axesColor;
	if (gl_FrontFacing) {
	  axesColor = texture(axes,TexCoord);
	} else {
	  axesColor = texture(axes,vec2(1-TexCoord[0],TexCoord[1]));
	}
    if (axesColor.a>0.1) {
	  fragColor = axesColor;
	}	
	fragColor.a=alpha*uv_fade;
	if (fragColor.r+fragColor.g+fragColor.b==0.0)discard;
}
