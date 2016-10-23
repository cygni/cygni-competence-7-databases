function (doc) {
  (doc.albums || []).forEach(function(album) {
      (album.tracks || []).forEach(function(track) {
          (track.tags || []).forEach(function(tag) {
            emit([tag.idstr, tag.weight], {track: track.name, artist: doc.name, weight: tag.weight});
          })
      })
  });
}