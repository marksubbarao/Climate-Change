layout(triangles) in;
layout(triangle_strip, max_vertices = 8) out;

uniform vec3 sunPos;
uniform vec3 earthPos;
uniform float spriteRadius;
uniform float markerAlpha;
uniform float animationPeriod;
uniform float overshoot;
uniform float radStart;
uniform float radEnd;
uniform float shortLength;
uniform float albedo;
uniform vec4 shortColor;
uniform mat4 uv_projectionMatrix;
uniform mat4 uv_modelViewMatrix;
uniform mat4 uv_modelViewInverseMatrix;
uniform mat4 uv_modelViewProjectionMatrix;
uniform mat4 uv_scene2ObjectMatrix;
uniform vec4 uv_cameraPos;
uniform int uv_simulationtimeDays;
uniform float uv_simulationtimeSeconds;
uniform float uv_fade;
const float EARTHRADIUS = 637.9;
out vec2 texcoord;
out vec4 color;
out float phase;

void drawLine(vec4 position0, vec4 position1, float width, float texBegin, float texEnd)
{
    vec3 viewPosition0 = (uv_modelViewMatrix * position0).xyz;
    vec3 viewPosition1 = (uv_modelViewMatrix * position1).xyz;
	vec3 normalDirection0 = normalize(cross(position0.xyz-position1.xyz,(uv_scene2ObjectMatrix*uv_cameraPos).xyz-position0.xyz));
	vec3 normalDirection1 = normalize(cross(position0.xyz-position1.xyz,(uv_scene2ObjectMatrix*uv_cameraPos).xyz-position1.xyz));
	vec3 side0 = (mat3(uv_modelViewMatrix)*normalDirection0*width);
	vec3 side1 = (mat3(uv_modelViewMatrix)*normalDirection1*width);
    //vec3 side = normalize(cross(viewPosition0, viewPosition1 - viewPosition0));

    texcoord = vec2(texBegin, 1);
    gl_Position = uv_projectionMatrix * vec4(viewPosition0 - side0, 1);
    EmitVertex();
    texcoord = vec2(texBegin, 0);
    gl_Position = uv_projectionMatrix * vec4(viewPosition0 + side0, 1);
    EmitVertex();

    texcoord = vec2(texEnd, 1);
    gl_Position = uv_projectionMatrix * vec4(viewPosition1 - side1, 1);
    EmitVertex();
    texcoord = vec2(texEnd, 0);
    gl_Position = uv_projectionMatrix * vec4(viewPosition1 + side1, 1);
    EmitVertex();
    EndPrimitive();
}


void main()
{
	float animation = fract((uv_simulationtimeSeconds)/animationPeriod);
    if(uv_fade<0.001)
        return;
	color=shortColor;
	float animationFactor = mod(animation+gl_in[0].gl_Position.z,1.0);
	phase = 6.28*animationFactor*(radEnd-radStart)/shortLength;
	float xPlane=(1.0+overshoot)*gl_in[0].gl_Position.x;
	float yPlane=(1.0+overshoot)*gl_in[0].gl_Position.y;
	float zEarth=-999.;
	//if ray will intersect Earth, calculate intersection point: vec3(xPlane,yPlane,zEarth)
	if ((xPlane*xPlane+yPlane*yPlane)<1.0){
	   zEarth = sqrt(1.0-xPlane*xPlane-yPlane*yPlane);
	} 
	vec3 pIntersect = vec3(xPlane,yPlane,-zEarth);
	float intersectDist = -radStart-zEarth;
    float radLength = radEnd -radStart;
	float headDistance=animationFactor*radLength+shortLength;
	float tailDistance=animationFactor*radLength;
	vec3 earthDirection = normalize(earthPos-sunPos);
	vec3 offRight = normalize(cross(earthDirection,vec3(0,0,1)));
	vec3 offUp = normalize(cross(offRight,earthDirection));
	vec3 offset=xPlane*offRight+yPlane*offUp;
	color.a*=min((radLength-tailDistance),min(tailDistance/shortLength,1.0));
	if (tailDistance<intersectDist) {
		vec4 lightPosStart = vec4(earthPos - EARTHRADIUS*((min(headDistance,intersectDist)+radStart)*earthDirection+offset),1.0);
		vec4 lightPosEnd = vec4(earthPos - EARTHRADIUS*((tailDistance+radStart)*earthDirection+offset),1.0);	
		drawLine(lightPosStart,lightPosEnd,0.01*spriteRadius,1-(min(headDistance,intersectDist)-tailDistance)/shortLength,1.);
	}
	float randval = gl_in[1].gl_Position[0];
	if (randval < albedo && headDistance > intersectDist){
		vec3 reflectionDir =  reflect(vec3(0,0,-1),normalize(pIntersect));
		vec3 headPosSunAlligned = (headDistance - intersectDist)*reflectionDir-pIntersect;
		vec3 tailPosSunAlligned = max((tailDistance - intersectDist),0.)*reflectionDir-pIntersect;
		//Highlight reflection
		if ((headDistance - intersectDist)/shortLength<3.0) {
		  color.rbg*=10.*(3.0-(headDistance - intersectDist)/shortLength);
		}
		headPosSunAlligned*=EARTHRADIUS;
		tailPosSunAlligned*=EARTHRADIUS;
		vec4 headPosModel = vec4(headPosSunAlligned.x*offRight+headPosSunAlligned.y*offUp+headPosSunAlligned.z*earthDirection,1.);
		vec4 tailPosModel = vec4(tailPosSunAlligned.x*offRight+tailPosSunAlligned.y*offUp+tailPosSunAlligned.z*earthDirection,1.);
		color.a*= min((radLength-tailDistance)/shortLength,1.0);
		drawLine(headPosModel,tailPosModel,0.01*spriteRadius,0,(headDistance-max(tailDistance,intersectDist))/shortLength);
	} 
}
  
  
  
  