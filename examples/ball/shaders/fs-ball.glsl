
uniform sampler2D t_normal;
uniform sampler2D t_audio;

varying vec2 vUv;
varying vec3 vVel;
varying vec4 vAudio;
varying vec3 vMPos;
varying vec3 vPos;

varying vec3 vNorm;
varying vec3 vMNorm;
varying vec3 vCamPos;

varying vec3 vLightDir;
varying float vLife;

varying vec3 vCamVec;

void main(){

  float texScale = .1;
  float normalScale = .05;

  // FROM @thespite
  vec3 n = normalize( vMNorm.xyz );
  vec3 blend_weights = abs( n );
  blend_weights = ( blend_weights - 0.2 ) * 7.;  
  blend_weights = max( blend_weights, 0. );
  blend_weights /= ( blend_weights.x + blend_weights.y + blend_weights.z );

  vec2 coord1 = vMPos.yz * texScale;
  vec2 coord2 = vMPos.zx * texScale;
  vec2 coord3 = vMPos.xy * texScale;

  vec3 bump1 = texture2D( t_normal , coord1 ).rgb;  
  vec3 bump2 = texture2D( t_normal , coord2  ).rgb;  
  vec3 bump3 = texture2D( t_normal , coord3  ).rgb; 

  vec3 blended_bump = bump1 * blend_weights.xxx +  
                      bump2 * blend_weights.yyy +  
                      bump3 * blend_weights.zzz;

  vec3 tanX = vec3( n.x, -n.z, n.y);
  vec3 tanY = vec3( n.z, n.y, -n.x);
  vec3 tanZ = vec3(-n.y, n.x, n.z);
  vec3 blended_tangent = tanX * blend_weights.xxx +  
                         tanY * blend_weights.yyy +  
                         tanZ * blend_weights.zzz; 

  vec3 normalTex = blended_bump * 2.0 - 1.0;
  normalTex.xy *= normalScale;
  normalTex.y *= -1.;
  normalTex = normalize( normalTex );
  mat3 tsb = mat3( normalize( blended_tangent ), normalize( cross( n, blended_tangent ) ), normalize( n ) );
  vec3 finalNormal = normalize(tsb * normalTex);

   
  float l =  100. / vMPos.y;
  vec4 aC = texture2D( t_audio , vec2( abs(dot( finalNormal , vec3( 1. , 0. , 0. ))), 0. ) );

  vec4 aC1 = texture2D( t_audio , vec2( abs(dot(vNorm , vec3( 1. , 0. , 0. ))), 0. ) );
 // aC *= texture2D( t_audio , vec2( vUv.x , 0. ) );
 // aC *= texture2D( t_audio , vec2( vUv.y , 0. ) );


  float lamb = max( 0. , dot( -vLightDir , finalNormal ));
  float refl = max( 0. , dot( reflect( vLightDir , finalNormal )  , vCamVec ));
 // float refl = vMPos - lightPos
  float fr = max( 0. , dot( vCamVec , finalNormal ));


  vec3 a = texture2D( t_audio , vec2( 1. - fr , 0. ) ).xyz;

  vec3 rC =  vec3( 1. , .8 , .3 ) * pow( refl , 30. );
  vec3 lC = vec3( .4 , .2 , .8 ) * pow( lamb , 1. );

  //gl_FragColor = vec4( vUv.x, vLife /10000., vUv.y, 1. ); //aC ; //* vec4(  1000. - vMPos.y , 100. / vMPos.y , .3, 1. );
 // gl_FragColor = vec4( vec3( .5 , .4 , .2 ) + vec3( 1. , 1. , .6 ) * aC.xyz * aC1.xyz , 1. ); //aC ; //* vec4(  1000. - vMPos.y , 100. / vMPos.y , .3, 1. );
  gl_FragColor = vec4( rC + lC , 1. );




}
