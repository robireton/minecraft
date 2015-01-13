from optimizeimages import optipng

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

worlds['wp'] = '/home/rob/Minecraft/servers/wp/world'
texturepath = '/home/rob/.minecraft'
outputdir = '/var/www/overviewer/wp'
customwebassets = '/home/rob/Minecraft/overviewer/assets'
world = 'wp'
rendermode = 'normal'
bgcolor = '#160C42'
defaultzoom = 5
#rerenderprob = 0.1

renders['surface_ul'] = {
    'title': 'upper-left',
    'northdirection': 'upper-left',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['surface_ur'] = {
    'title': 'upper-right',
    'northdirection': 'upper-right',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['surface_lr'] = {
    'title': 'lower-right',
    'northdirection': 'lower-right',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['surface_ll'] = {
    'title': 'lower-left',
    'northdirection': 'lower-left',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['caves_ul'] = {
    'title': 'cave - upper-left',
    'northdirection': 'upper-left',
    'rendermode': 'cave',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['caves_ur'] = {
    'title': 'cave - upper-right',
    'northdirection': 'upper-right',
    'rendermode': 'cave',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['caves_lr'] = {
    'title': 'cave - lower-right',
    'northdirection': 'lower-right',
    'rendermode': 'cave',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}

renders['caves_ll'] = {
    'title': 'cave - lower-left',
    'northdirection': 'lower-left',
    'rendermode': 'cave',
    'markers': myMarkers,
    'optimizeimg':[optipng(olevel=2)],
}
