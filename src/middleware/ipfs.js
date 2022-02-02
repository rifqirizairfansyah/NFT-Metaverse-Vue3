import { create } from 'ipfs-http-client'
const projectId = '22zcdn2w6HUYvyJyxxcwdiBt4rt'
const projectSecret = 'e1cfee7a2b91be6be2285fc3cfad2094'
const auth = 'Basic ' + Buffer.from(projectId + ':' + projectSecret).toString('base64')
/**
 * creates & exports new instance for
 * IPFS using infura as host, for use.
 */

const ipfs = create({
  host: 'ipfs.infura.io',
  port: 5001,
  protocol: 'https',
  headers: {
    authorization: auth
  }
})

// const ipfs = create(new URL)

export default ipfs
