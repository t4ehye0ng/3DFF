/* This is free and unencumbered software released into the public domain. */

import 'dart:convert' show htmlEscape;

import 'package:flutter/material.dart';

abstract class HTMLBuilder {
  HTMLBuilder._();

  static String build(
      {final String htmlTemplate = '',
      @required final String src,
      final Color backgroundColor = const Color(0xFFFFFF),
      final String alt,
      final bool ar,
      final List<String> arModes,
      final String arScale,
      final bool autoRotate,
      final int autoRotateDelay,
      final bool autoPlay,
      final bool cameraControls,
      final String geometry,
      final String iosSrc}) {
    final html = StringBuffer(htmlTemplate);
    // html.write('<model-viewer');
    // html.write(' src="${htmlEscape.convert(src)}"');
    // html.write(
    //     ' style="background-color: rgb(${backgroundColor.red}, ${backgroundColor.green}, ${backgroundColor.blue});"');
    if (alt != null) {
      html.write(' alt="${htmlEscape.convert(alt)}"');
    }
    // TODO: animation-name
    // TODO: animation-crossfade-duration
    if (ar ?? false) {
      html.write(' ar');
    }
    if (arModes != null) {
      html.write(' ar-modes="${htmlEscape.convert(arModes.join(' '))}"');
    }
    if (arScale != null) {
      html.write(' ar-scale="${htmlEscape.convert(arScale)}"');
    }
    if (autoRotate ?? false) {
      html.write(' auto-rotate');
    }
    if (autoRotateDelay != null) {
      html.write(' auto-rotate-delay="$autoRotateDelay"');
    }
    if (autoPlay ?? false) {
      html.write(' autoplay');
    }

    if (geometry != null) {
      html.write(geometry);
    }

    // TODO: skybox-image
    if (cameraControls ?? false) {
      html.write(' camera-controls');
    }
    // TODO: camera-orbit
    // TODO: camera-target
    // TODO: environment-image
    // TODO: exposure
    // TODO: field-of-view
    // TODO: interaction-policy
    // TODO: interaction-prompt
    // TODO: interaction-prompt-style
    // TODO: interaction-prompt-threshold
    if (iosSrc != null) {
      html.write(' ios-src="${htmlEscape.convert(iosSrc)}"');
    }
    // TODO: max-camera-orbit
    // TODO: max-field-of-view
    // TODO: min-camera-orbit
    // TODO: min-field-of-view
    // TODO: poster
    // TODO: loading
    // TODO: quick-look-browsers
    // TODO: reveal
    // TODO: shadow-intensity
    // TODO: shadow-softness
    // html.writeln('></model-viewer>');
    html.write(lights);
    html.write(geometry2);
    html.write(animate);
    html.write(bottom);

    return html.toString();
  }
}

final String geometry3 = """
    const geometry = new THREE.BoxGeometry();
    const material = new THREE.MeshPhongMaterial( { color: 0x005E99 } );  //0x00ff00
    // const material = new THREE.MeshBasicMaterial( { color: 0x00ff00, wireframe: false } ); 
    const mesh = new THREE.Mesh( geometry, material );
    scene.add( mesh );
""";

final String geometry2 = """
    const geometry = new THREE.SphereGeometry( 1, 12, 12 );
    // const geometry = new THREE.BoxGeometry();
    // const material = new THREE.MeshBasicMaterial( {color: 0xffff00} );
    const material = new THREE.MeshPhongMaterial( { color: 0x00ff00 } );  0x005E99
    const mesh = new THREE.Mesh( geometry, material );
    scene.add( mesh );
""";
// const geometry = new THREE.BufferGeometry();
// const vertices = new Float32Array( [
//   -1.0, -1.0,  1.0,
//   1.0, -1.0,  1.0,
//   1.0,  1.0,  1.0,

//   1.0,  1.0,  1.0,
//   -1.0,  1.0,  1.0,
//   -1.0, -1.0,  1.0
// ] );
//     const material = new THREE.MeshPhongMaterial( { color: 0x00ff00 } );
// geometry.setAttribute( 'position', new THREE.BufferAttribute( vertices, 3 ) );
// const material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
// const material = new THREE.MeshPhongMaterial();

final String lights = """
  const lights = [];
  lights[0] = new THREE.PointLight( 0xffffff, 1, 0 );
  lights[1] = new THREE.PointLight( 0xffffff, 1, 0 );
  lights[2] = new THREE.PointLight( 0xffffff, 1, 0 );

  lights[0].position.set( 0, 200, 0 );
  lights[1].position.set( 100, 200, 100 );
  lights[2].position.set( - 100, - 200, - 100 );

  scene.add( lights[0] );
  scene.add( lights[1] );
  scene.add( lights[2] );
""";

final String animate = """
    const animate = function () {
        requestAnimationFrame( animate );

        mesh.rotation.x += 0.01;
        mesh.rotation.y += 0.01;

        renderer.render( scene, camera );
    };

    animate();
""";

final String bottom = """</script></body></html>""";
