uniform float uv_fade;
uniform int uv_simulationtimeDays;
uniform sampler2D tempData;
uniform float alpha;
out vec4 fragColor;

void main(void)
{
	float years = uv_simulationtimeDays/365.25+1970.;
	//Using the GISS (J-D) measurment which is good from Jan 1 1880 to Dec 31 2016 
	if (years<1880.0 || years>2017.0) discard;
	float texVal= (years-1880.0)/137.0;
	vec4 yearColor=texture(tempData,vec2(texVal,0.5));
	if (yearColor.r<0.5) {
	  fragColor = vec4(0.0,1.0,1.0,2.56*(0.5-yearColor.r));
	} else {
	  fragColor = vec4(1.0,0.0,0.0,2.56*(yearColor.r-0.5));
	}
	fragColor.a*=0.95*uv_fade*alpha;	
}
