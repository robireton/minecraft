# -*- coding: utf-8 -*-
from optimizeimages import optipng

global color_name
color_name = {0: 'White', 1: 'Orange', 2: 'Magenta', 3: 'Light Blue', 4: 'Yellow', 5: 'Lime', 6: 'Pink', 7: 'Gray', 8: 'Light Gray', 9: 'Cyan', 10: 'Purple', 11: 'Blue', 12: 'Brown', 13: 'Green', 14: 'Red', 15: 'Black'}

def sheepFilter(entity):
  if entity['id'] == 'Sheep':
    if entity['Age'] < 0:
      entity['icon'] = 'Sheep-Baby.png'
    elif entity['Sheared']:
      entity['icon'] = 'Sheep-Sheared.png'
    else:
      entity['icon'] = 'Sheep-%s.png' % color_name[entity['Color']]
    description = 'Lamb' if entity['Age'] < 0 else 'Sheep'
    if entity['Color'] > 0:
      description = color_name[entity['Color']] + ' ' + description
    if entity['Sheared']:
      description = 'Shorn ' + description
    return description

def pigFilter(entity):
  if entity['id'] == 'Pig':
    description = 'Piglet' if entity['Age'] < 0  else 'Pig'
    entity['icon'] = 'Pig-Baby.png' if entity['Age'] < 0 else 'Pig.png'
    return description

def cowFilter(entity):
  if entity['id'] == 'Cow':
    description = 'Calf' if entity['Age'] < 0  else 'Cow'
    entity['icon'] = 'Cow-Baby.png' if entity['Age'] < 0 else 'Cow.png'
    return description

def chickenFilter(entity):
  if entity['id'] == 'Chicken':
    description = 'Chick' if entity['Age'] < 0  else 'Chicken'
    entity['icon'] = 'Chicken-Baby.png' if entity['Age'] < 0 else 'Chicken.png'
    return description

def signFilter(entity):
    if entity['id'] == 'Sign':
        return '\n'.join([entity['Text1'], entity['Text2'], entity['Text3'], entity['Text4']])

def containerFilter(entity):
    if entity['id'] in ['Chest', 'Trap', 'Furnace', 'Dropper'] and len(entity['Items']) > 0:
        item_sum = 0
        for item in entity['Items']:
            item_sum += item['Count']
        entity['icon'] = '%s.png' % entity['id']
        return '\n'.join(['%s at' % entity['id'], 'position [%i, %i, %i]' % (entity['x'], entity['y'], entity['z']), 'with %i items' % item_sum, 'in %i slots ' % len(entity['Items'])])

def spawnerFilter(entity):
    if entity['id'] == 'MobSpawner':
        return '\n'.join(['%s Spawner' % entity['EntityId'], 'position [%i, %i, %i]' % (entity['x'], entity['y'], entity['z']) ])

def playerIcons(entity):
    if entity['id'] == 'Player':
        entity['icon'] = 'http://overviewer.org/avatar/%s' % entity['EntityId']
        return 'Last known location for %s %s' % (entity['EntityId'], [ int(round(x)) for x in entity['Pos'] ])

def catFilter(entity):
    if entity['id'] == 'Ozelot':
        entity['icon'] = {0: 'Ocelot.png', 1: 'Tuxuedo.png', 2: 'Tabby.png', 3: 'Siamese.png'}[entity['CatType']]
        return {0: 'Wild Ocelot', 1: 'Tuxuedo Cat', 2: 'Tabby Cat', 3: 'Siamese Cat'}[entity['CatType']]

def wolfFilter(entity):
    if entity['id'] == 'Wolf':
        description = 'Wolf'
        if 'OwnerUUID' in entity and entity['OwnerUUID']:
            entity['icon'] = 'Wolf-tame.png'
            description = 'Dog'
        else:
            entity['icon'] = 'Wolf-aggressive.png' if entity['Angry'] else 'Wolf-wild.png'
            description = 'Angry Wolf' if entity['Angry'] else 'Wild Wolf'
        return description

def horseFilter(entity):
    if entity['id'] == 'EntityHorse' and entity['Type'] in [0, 1, 2]:
        horseType = {0: 'Horse', 1: 'Donkey', 2: 'Mule'}[entity['Type']]
        entity['icon'] = '%s.png' % horseType
        if entity['Type'] == 0:
            baseColor = entity['Variant'] & 0x00FF
            pattern = (entity['Variant'] & 0xFF00) >> 8
            horseType = {0: 'White ', 1: 'Buckskin ', 2: 'Chestnut ', 3: 'Bay ', 4: 'Black ', 5: 'Gray ', 6: 'Chestnut '}[baseColor] + horseType
            if pattern > 0:
                horseType = horseType + {1: ' with White', 2: ' with White Paint', 3: ' with White Spots', 4: ' with Black', }[pattern]
        for attribute in entity['Attributes']:
            if attribute['Name'] == 'generic.movementSpeed':
                horseType = horseType + "\nspeed: %i" % (43*(0.69999998807907104 + attribute['Base']))
        if entity['Tame']:
            horseType = 'Tame ' + horseType
        return "%s\nat %s" % (horseType, [ int(round(x)) for x in entity['Pos'] ])


def villagerFilter(entity):
    if entity['id'] == 'Villager':
        profession = {0: 'Farmer', 1: 'Librarian', 2: 'Priest', 3: 'Blacksmith', 4: 'Butcher'}[entity['Profession']]
        entity['icon'] = '%s.png' % profession
        if 'Career' in entity:
            if entity['Profession'] == 0:
                profession = profession + {0: ' - Novice', 1: ' - Professional', 2: ' - Fisherman', 3: ' - Shepherd', 4: ' - Fletcher'}[entity['Career']]
            if entity['Profession'] == 2 and entity['Career'] == 1:
                profession = profession + ' - Cleric'
            elif entity['Profession'] == 3:
                profession = profession + {0: ' - Novice', 1: ' - Armorer', 2: ' - Weapon Smith', 3: ' - Tool Smith'}[entity['Career']]
            elif entity['Profession'] == 4:
                profession = profession + {0: ' - Novice', 1: ' - Professional', 2: ' - Leatherworker'}[entity['Career']]
            profession = '%s (level %d)' % (profession, entity['CareerLevel'])
        return profession

myMarkers = [
    dict(name='Players',      filterFunction=playerIcons, checked=True),
    dict(name='Villagers',    filterFunction=villagerFilter),
    dict(name='Horses',       filterFunction=horseFilter),
    dict(name='Cats',         filterFunction=catFilter),
    dict(name='Wolves',       filterFunction=wolfFilter),
    dict(name='Signs',        filterFunction=signFilter),
    dict(name='Containers',   filterFunction=containerFilter),
    dict(name='Mob Spawners', filterFunction=spawnerFilter, icon='MobSpawner.png'),
]

worlds['Western Paquet'] = '/home/rob/Minecraft/servers/wp/world'
worlds['Crickhowell']    = '/home/rob/Minecraft/servers/ch/world'
worlds['lan']            = '/home/rob/Minecraft/servers/lan/world'
texturepath              = '/home/rob/Minecraft/resourcepacks/paper_cutout_2_17.zip'
outputdir                = '/home/rob/Minecraft/overviewer/maps'
customwebassets          = '/home/rob/Minecraft/overviewer/assets'
smooth_render = [Base(), SmoothLighting()]
markers = [
    dict(name='Players',      filterFunction=playerIcons, checked=True),
    dict(name='Villagers',    filterFunction=villagerFilter),
    dict(name='Chickens',     filterFunction=chickenFilter),
    dict(name='Cows',         filterFunction=cowFilter),
    dict(name='Pigs',         filterFunction=pigFilter),
    dict(name='Sheep',        filterFunction=sheepFilter),
    dict(name='Horses',       filterFunction=horseFilter),
    dict(name='Cats',         filterFunction=catFilter),
    dict(name='Wolves',       filterFunction=wolfFilter),
    dict(name='Signs',        filterFunction=signFilter),
    dict(name='Containers',   filterFunction=containerFilter),
    dict(name='Mob Spawners', filterFunction=spawnerFilter, icon='MobSpawner.png'),
]
optimizeimg = [optipng(olevel=2)]
bgcolor = '#160C42'
defaultzoom = 5
#rerenderprob = 0.1


renders['wp_ul'] = {
    'world': 'Western Paquet',
    'title': 'Above - ↖',
    'northdirection': 'upper-left',
    'rendermode': smooth_render,
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_ur'] = {
    'world': 'Western Paquet',
    'title': 'Above - ↗',
    'northdirection': 'upper-right',
    'rendermode': smooth_render,
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_lr'] = {
    'world': 'Western Paquet',
    'title': 'Above - ↘',
    'northdirection': 'lower-right',
    'rendermode': smooth_render,
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_ll'] = {
    'world': 'Western Paquet',
    'title': 'Above - ↙',
    'northdirection': 'lower-left',
    'rendermode': smooth_render,
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_ul_cave'] = {
    'world': 'Western Paquet',
    'title': 'Below - ↖',
    'northdirection': 'upper-left',
    'rendermode': 'cave',
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_ur_cave'] = {
    'world': 'Western Paquet',
    'title': 'Below - ↗',
    'northdirection': 'upper-right',
    'rendermode': 'cave',
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_lr_cave'] = {
    'world': 'Western Paquet',
    'title': 'Below - ↘',
    'northdirection': 'lower-right',
    'rendermode': 'cave',
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_ll_cave'] = {
    'world': 'Western Paquet',
    'title': 'Below - ↙',
    'northdirection': 'lower-left',
    'rendermode': 'cave',
    'crop': (-2500, -2000, 2500, 2000),
}

renders['wp_danger'] = {
  'world': 'Western Paquet',
  'title': 'Danger',
  'northdirection': 'upper-left',
  'overlay': ['wp_ul'],
  'rendermode': [ ClearBase(), SpawnOverlay() ],
}

renders['wp_minerals'] = {
  'world': 'Western Paquet',
  'title': 'Minerals',
  'northdirection': 'upper-left',
  'overlay': ['wp_ul'],
  'rendermode': [ ClearBase(), MineralOverlay() ],
}





renders['ch_ul'] = {
    'world': 'Crickhowell',
    'title': 'Above - ↖',
    'northdirection': 'upper-left',
    'rendermode': smooth_render,
}

renders['ch_ur'] = {
    'world': 'Crickhowell',
    'title': 'Above - ↗',
    'northdirection': 'upper-right',
    'rendermode': smooth_render,
}

renders['ch_lr'] = {
    'world': 'Crickhowell',
    'title': 'Above - ↘',
    'northdirection': 'lower-right',
    'rendermode': smooth_render,
}

renders['ch_ll'] = {
    'world': 'Crickhowell',
    'title': 'Above - ↙',
    'northdirection': 'lower-left',
    'rendermode': smooth_render,
}

renders['ch_ul_cave'] = {
    'world': 'Crickhowell',
    'title': 'Below - ↖',
    'northdirection': 'upper-left',
    'rendermode': 'cave',
}

renders['ch_ur_cave'] = {
    'world': 'Crickhowell',
    'title': 'Below - ↗',
    'northdirection': 'upper-right',
    'rendermode': 'cave',
}

renders['ch_lr_cave'] = {
    'world': 'Crickhowell',
    'title': 'Below - ↘',
    'northdirection': 'lower-right',
    'rendermode': 'cave',
}

renders['ch_ll_cave'] = {
    'world': 'Crickhowell',
    'title': 'Below - ↙',
    'northdirection': 'lower-left',
    'rendermode': 'cave',
}





renders['lan_ul'] = {
    'world': 'lan',
    'title': 'Above - ↖',
    'northdirection': 'upper-left',
    'rendermode': smooth_render,
}

renders['lan_ur'] = {
    'world': 'lan',
    'title': 'Above - ↗',
    'northdirection': 'upper-right',
    'rendermode': smooth_render,
}

renders['lan_lr'] = {
    'world': 'lan',
    'title': 'Above - ↘',
    'northdirection': 'lower-right',
    'rendermode': smooth_render,
}

renders['lan_ll'] = {
    'world': 'lan',
    'title': 'Above - ↙',
    'northdirection': 'lower-left',
    'rendermode': smooth_render,
}

renders['lan_ul_cave'] = {
    'world': 'lan',
    'title': 'Below - ↖',
    'northdirection': 'upper-left',
    'rendermode': 'cave',
}

renders['lan_ur_cave'] = {
    'world': 'lan',
    'title': 'Below - ↗',
    'northdirection': 'upper-right',
    'rendermode': 'cave',
}

renders['lan_lr_cave'] = {
    'world': 'lan',
    'title': 'Below - ↘',
    'northdirection': 'lower-right',
    'rendermode': 'cave',
}

renders['lan_ll_cave'] = {
    'world': 'lan',
    'title': 'Below - ↙',
    'northdirection': 'lower-left',
    'rendermode': 'cave',
}

