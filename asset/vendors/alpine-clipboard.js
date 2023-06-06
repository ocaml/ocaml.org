// from https://cdn.jsdelivr.net/npm/@ryangjchandler/alpine-clipboard@2.x.x/dist/alpine-clipboard.js
/*
  Copyright (c) 2021 Ryan Chandler and contributors

  Licensed under the MIT license
*/
(function (factory) {
    typeof define === 'function' && define.amd ? define(factory) :
    factory();
}((function () { 'use strict';

    let onCopy = () => {};

    function Clipboard(Alpine) {
      Alpine.magic('clipboard', () => {
        return function (target) {
          if (typeof target === 'function') {
            target = target();
          }

          if (typeof target === 'object') {
            target = JSON.stringify(target);
          }

          return window.navigator.clipboard.writeText(target).then(onCopy);
        };
      });
    }

    Clipboard.configure = config => {
      if (config.hasOwnProperty('onCopy') && typeof config.onCopy === 'function') {
        onCopy = config.onCopy;
      }

      return Clipboard;
    };

    document.addEventListener('alpine:initializing', () => {
      Clipboard(window.Alpine);
    });

})));
