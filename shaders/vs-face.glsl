
uniform sampler2D t_pos;
uniform sampler2D t_oPos;
uniform sampler2D t_audio;
uniform sampler2D t_og;

varying vec2 vUv;
varying vec3 vVel;

varying vec3 vMPos;

varying float vLife;
varying vec4 vAudio;

void main(){

  vUv = position.xy;
  //vec4 pos = texture2D( t_pos , vec2( vUv.x , (1. - (vUv.y + .125)) ) );
  vec4 pos = texture2D( t_pos , vUv );
  vec4 oPos = texture2D( t_oPos , vUv );
  vec4 ogPos = texture2D( t_og , vUv );


  vVel = pos.xyz - oPos.xyz;

  vLife = position.z;


  vMPos = ( modelMatrix * vec4( pos.xyz , 1. ) ).xyz;

  vAudio = texture2D( t_audio , vec2( vUv.x , 0. ) );
  gl_Position = projectionMatrix * modelViewMatrix * vec4( position.x , position.y , 0. , 1. );
  gl_Position = projectionMatrix * modelViewMatrix * vec4( pos.xyz , 1. );


}

