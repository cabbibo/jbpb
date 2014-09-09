
uniform sampler2D t_sprite;
uniform sampler2D t_audio;

varying vec2 vUv;
varying vec3 vVel;
varying vec4 vAudio;
varying vec3 vMPos;

varying float vLife;

void main(){

   
  float l =  100. / vMPos.y;
  vec4 aC = texture2D( t_audio , vec2( vLife , 0. ) );
 // aC *= texture2D( t_audio , vec2( vUv.x , 0. ) );
 // aC *= texture2D( t_audio , vec2( vUv.y , 0. ) );

  gl_FragColor = vec4( vUv.x, vLife /100., vUv.y, 1. ); //aC ; //* vec4(  1000. - vMPos.y , 100. / vMPos.y , .3, 1. );

}
