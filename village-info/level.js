const fs = require('fs')
const nbt = require('prismarine-nbt')
const level = 'World B'
// const level = 'The World'
// const level = 'Land & Sea · Again'
// const level = 'Land & Sea · Trip'
// const level = 'Coastline'

fs.readFile(`/Users/rob/Library/Application Support/minecraft/saves/${level}/data/map_41.dat`, (error, data) => {
  if (error) throw error;

  nbt.parse(data, (error, data) => {
    console.log(JSON.stringify(data))
    // for (village of data.value.data.value.Villages.value.value) {
    //   console.log({
    //     'center': `${village.CX.value} ${village.CY.value} ${village.CZ.value}`,
    //     'radius': village.Radius.value,
    //     'population': village.PopSize.value,
    //     'doors': village.Doors.value.value.length
    //   })
    // }
  })
})
