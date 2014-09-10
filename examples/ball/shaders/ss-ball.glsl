uniform sampler2D t_oPos;
uniform sampler2D t_pos;
uniform sampler2D t_og;
uniform float dT;
uniform float timer;

uniform vec3 repelers[ 25 ];

varying vec2 vUv;


$simplex
$curl

void main(){


  
  vec4 oPos = texture2D( t_oPos , vUv );
  vec4 pos  = texture2D( t_pos , vUv );

  vec4 og   = texture2D( t_og , vUv );
  vec3 vel  = pos.xyz - oPos.xyz;
  vec3 p    = pos.xyz;

  float life = pos.w;
  
  vec3 f = vec3( 0. , 0. , 0. );
 
  vec3 dif = pos.xyz - og.xyz;

  vec3 repel = pos.xyz - vec3( 1. , 0. , 0. );

  for( int i = 0; i < 25; i++ ){

    vec3  rP = repelers[ i ];
    vec3  rD = pos.xyz - rP;
    float rL = length( rD );
    vec3  rN = normalize( rD );

    //if( rL < 5. ){

      f += 1.1 *  rN / rL;

        //f -= rN;


   // }


  }


  f -= dif;
 
  vel += f*dT;
  vel *= .95;
  p += vel * 1.;//speed;*/



  //gl_FragColor = vec4( og.xyz + sin( timer ) * 1.* vec3( vUv.x , vUv.y , 0. ), 1.  );
  gl_FragColor = vec4( p , life );

}
