in vec2 uv_texCoordAttrib0;
uniform float uv_fade;
in float DistanceFade;
in vec3 VertexDir;
in vec2 TexCoord;
//out vec4 color;

uniform float AlphaMultiplier;
uniform float sakuraPlotStart;
uniform float sakuraPlotHeight;
uniform vec3 ColorMultiplier;
uniform vec4 measuredColor;
uniform vec4 correctedColor;
uniform float yearPlot;
uniform float graphAlpha;
uniform sampler2D sakuraFisheye;
uniform sampler2D sakuraData;
uniform sampler2D yearLabels;
uniform sampler2D degreeLabels;

const float PI = 3.1415926535897932384626433;
void main()
{	
	vec3 positionOnUnitSphere = normalize(VertexDir);
    vec4 texColor=vec4(0.0,0.0,0.0,1.0);
	vec4 color;
	
    // map Fisheye image of cherry blossoms to color variable
    float r = min(0.5,TexCoord[1]);
    float theta = 2.0*PI*TexCoord[0];
	vec2 coord = vec2(0.5+r*sin(theta), 0.5-r*cos(theta));
	texColor = texture2D(sakuraFisheye,coord.st);
	color = vec4(texColor.rgb*ColorMultiplier.rgb, AlphaMultiplier*texColor.w*uv_fade*DistanceFade);					  		

    //add graph
	float graphTop = sakuraPlotStart-sakuraPlotHeight;
	float graphBottom = sakuraPlotStart;
	float yearMin = 850.;
	float yearMax=2040;
	float plotRange=0.9;
	float FujiBuffer=0.05;
	float graphFade=color.a*graphAlpha;
	if (TexCoord.y>0.5 ) {discard;}
	float yearEnd=min(yearPlot,yearMax);
	float graphBegin = plotRange*(yearEnd-yearMin)/(yearMax-yearMin);
	if (yearPlot >yearMin){
		if (TexCoord.y>graphTop && TexCoord.y<graphBottom && TexCoord.x>(1.-graphBegin-FujiBuffer)&&TexCoord.x<(1-FujiBuffer) ) {
			color.rgb=mix(color.rgb,0.4*color.rgb,graphFade);
			// Calculate year cooresponding to the fragment
			float dataMin=816.;
			float dataMax=1996.;
			float yearFrag = yearEnd+(yearMin-yearEnd)*(1-TexCoord.x-FujiBuffer)/graphBegin;
			vec4 dataColor=texture(sakuraData,vec2((yearFrag-dataMin)/(dataMax-dataMin),0.5));
			float tempMin=4.67;
			float tempMax=8.3;
			float tempGraphMin=4.1;
			float tempGraphMax=8.6;
			float degLabWidth = 0.0125;
            float xAxisWidth = 0.015;
			float fragTemp = tempGraphMin+(tempGraphMax-tempGraphMin)*(graphBottom-TexCoord.y)/(graphBottom-graphTop);
            //draw graph lines
			if (mod(yearFrag, 100)<1.0 && TexCoord.x < (1-degLabWidth-FujiBuffer) && TexCoord.y<(graphBottom-xAxisWidth)) {color==mix(color,vec4(.5),graphFade);}
			if (mod(fragTemp,1.0)<0.04 && TexCoord.x < (1-degLabWidth-FujiBuffer)){color=mix(color,vec4(.5),graphFade);}
			// Check to make sure this data value isn't masked
			if (yearFrag > dataMin && yearFrag < dataMax && TexCoord.x < (1-1.1*degLabWidth-FujiBuffer)) {
				if (dataColor.b < 0.5) {
					float correctedTemp = mix(tempMin,tempMax,dataColor.g);
			        if (abs(correctedTemp-fragTemp) <0.04) {
						color=mix(color,correctedColor.a*correctedColor + (1.0-correctedColor.a)*color,graphFade);
					}
					float graphTemp = mix(tempMin,tempMax,dataColor.r);
			        if (abs(graphTemp-fragTemp) <0.04) {
						color=mix(color,measuredColor.a*measuredColor + (1.0-measuredColor.a)*color,graphFade);
					}
				}
			}
			//axis labels
			float yLabelMax = graphBottom;
			float yLabelMin = yLabelMax-0.015;
			if (TexCoord.y<yLabelMax&&TexCoord.y>yLabelMin&&TexCoord.x < (1-degLabWidth-FujiBuffer)){
			    // tear Labels
				float yearLabelWidth = 25.0;
				float yearInt = mod(yearFrag+yearLabelWidth/2,100);
				if (yearInt<yearLabelWidth) {
					float xLabSamp=yearInt/yearLabelWidth;
					float yLabSamp=1.-floor((yearFrag+yearLabelWidth/2.-800.)/100.)/13.-(TexCoord.y-yLabelMin)/((yLabelMax-yLabelMin)*13.);
					vec4 colorSamp =texture(yearLabels,vec2(xLabSamp,yLabSamp));
					color += graphFade*colorSamp.a*colorSamp;
				}
			}
			if (TexCoord.x > (1-degLabWidth-FujiBuffer)){
				float tempLabelWidth = 0.5;
				float tempInt = mod(fragTemp+tempLabelWidth/2.,1); 
				if (tempInt<tempLabelWidth){
					float xDegSamp = (TexCoord.x -1.0 + degLabWidth-FujiBuffer)/degLabWidth;
					float yDegSamp = (tempInt)/2. - floor(fragTemp+tempLabelWidth/2. -4.)/4.;
					if (floor(fragTemp+tempLabelWidth/2.)>4.0) {
						vec4 colorSamp=texture(degreeLabels,vec2(xDegSamp,yDegSamp));
						color += graphFade*colorSamp.a*colorSamp;
					}
				}
			}
		}
	}

	gl_FragColor = color;    			
	
}