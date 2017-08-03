layout(triangles) in;
layout(triangle_strip, max_vertices = 8) out;

uniform float spriteRadius;
uniform float animationPeriod;
uniform float overshoot;
uniform float radEnd;
uniform float radStart;
uniform float longLength;
uniform vec4 longColor;
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
	float animation = fract((uv_simulationtimeSeconds)/animationPeriod)*(radEnd)/radEnd;
    if(uv_fade<0.001)
        return;
	float animationFactor = mod(animation+gl_in[1].gl_Position.x,1.0);
	phase = 6.28*animationFactor*(radEnd-radStart)/longLength;
	vec4 headPos=EARTHRADIUS*(animationFactor*radEnd+1.0)*gl_in[0].gl_Position;
	vec4 tailPos=EARTHRADIUS*(animationFactor*radEnd+1.0-longLength)*gl_in[0].gl_Position;
	headPos[3]=1.0;
	tailPos[3]=1.0;
	color = longColor;
	color.a*=min(1.0,20.*(1.0-animationFactor));
	drawLine(headPos,tailPos,.0075*spriteRadius,0.0,1.);

}
  
  
  
  