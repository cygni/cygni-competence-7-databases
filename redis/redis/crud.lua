-- Hashes

redis.call('HSET', 'jon', 'name', 'Jon Persson')
redis.call('HSET', 'jon', 'speciality', 'wap')


-- Sets

redis.call('SADD', 'jon:competences', 'software project management', 'wap', 'open source', 'agile methodologies', 'scrum', 'software development', 'java', 'soap', 'it strategy', 'ant', 'rest', 'ftp')

-- Sorted sets
