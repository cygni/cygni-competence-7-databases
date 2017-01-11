if redis.call('get', KEYS[1]) == 'bar' then
	return redis.call('set',KEYS[1],'bars')
else
	return redis.call('set',KEYS[1],'bar')
end