const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
const gClipboardHelper = Cc['@mozilla.org/widget/clipboardhelper;1']
      .getService(Ci.nsIClipboardHelper);
const {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {});

const FIREFOX_PREFS = {
  'browser.startup.page': 3, // resume previous session
  'browser.tabs.animate': false,
  'browser.search.suggest.enabled': true,
  'browser.urlbar.suggest.searches': true,
  'browser.urlbar.maxRichResults': 20,
  'browser.tabs.remote.force-enable': true,
  'dom.ipc.processCount': 4
};

const MAPPINGS = {
  'go_home': '',
  'stop': '<c-escape>',
  'stop_all': 'a<c-escape>',

  'scroll_page_down': '<c-d>',
  'scroll_page_up': '<c-u>',
  'scroll_half_page_down': '<c-f>',
  'scroll_half_page_up': '<c-b>',
  'mark_scroll_position': 'mm',
  'scroll_to_mark': 'gm',

  'tab_new': 'T',
  'tab_new_after_current': 't',
  'tab_close': 'd x',
  'tab_restore': 'u',
  'tab_restore_list': 'U',
  'tab_select_previous': 'J gT <c-p>',
  'tab_select_next': 'K gt <c-n>',
  'tab_select_first_non_pinned': '^',
  'tab_select_last': '$',

  'enter_mode_ignore': 'I',
  'quote': 'i',

  'custom.mode.normal.search_selected_text': 's',
};

const {commands} = vimfx.modes.normal;
Object.entries(MAPPINGS).forEach(([cmd, key]) => {
  if (!cmd.includes('.')) {
    cmd = `mode.normal.${cmd}`;
  }
  vimfx.set(cmd, key);
});




const CUSTOM_COMMANDS = [
  [
    {
      name: 'search_selected_text',
      description: 'Search for the selected text'
    },
    ({vim}) => {
      vimfx.send(vim, 'getSelection', true, selection => {
        if (selection != '') {
          vim.window.switchToTabHavingURI(`https://www.google.co.jp/search?q=${selection}`, true);
        }
      });
    }
  ]
];

CUSTOM_COMMANDS.forEach(
  ([options, fn]) => {
    vimfx.addCommand(options, fn);
  }
);


/*
const SPEED_DIAL = [
  ['1', 'https://google.com/', 'google'],
  ['2', 'http://www.alc.co.jp/', 'alc'],
  ['3', 'http://ejje.weblio.jp/', 'weblio_eiji'],
  ['4', 'http://www.weblio.jp/', 'weblio'],

  ['5', null, ''],
  ['6', null, ''],
  ['7', null, ''],
  ['8', 'https://www.amazon.co.jp/', 'amazon'],

  ['9', null],
  ['10', null],
  ['11', 'http://docs.python.jp/3/library/index.html', 'python'],
  ['12', 'http://docs.python.jp/2/library/index.html', 'python_old'],

  ['13', 'https://github.com/cocuh?tab=repositories', 'github'],
  ['14', 'https://twitter.com/', 'twitter'],
  ['15', null],
  ['16', null],

  ['17', null],
  ['18', null],
  ['19', null],
  ['20', null],

  ['21', null],
  ['22', null],
  ['23', null],
  ['24', null],
];

const shift_num_symbol = [')', '!', '@', '#', '$', '%', '^', '&', '*', '('];
SPEED_DIAL
  .filter(([id, url, name]) => url !== null)
  .forEach(
  ([id, url, name]) => {
    var key = id.split('').map((k)=>`<c-${k}>`).join('');
    var key_shift = id.split('').map((k)=>`<c-${shift_num_symbol[parseInt(k)]}>`).join('');
    vimfx.addCommand(
      {
        name: `speed_dial_${name}`,
        description: `speed_dial ${id} ${name}`,
      },
      ({vim}) => {
        vim.notify(`speed dial ${name} ${key} ${url}`);
        vim.window.gBrowser.loadURI(url);
        //vim.window.switchToTabHavingURI(url, true);
      }
    );
    vimfx.addCommand(
      {
        name: `speed_dial_${name}_newtab`,
        description: `speed_dial_newtab ${id} ${url} ${name}`,
      },
      ({vim}) => {
        vim.notify(`speed dial ${name} ${key} ${url}`);
        vim.window.switchToTabHavingURI(url, true);
      }
    );
    vimfx.set(`custom.mode.normal.speed_dial_${name}`, `${key}<Space>`);
    vimfx.set(`custom.mode.normal.speed_dial_${name}_newtab`, `${key_shift}<Space>`);
  }
);
*/



Preferences.set(FIREFOX_PREFS);

prevent_autofocus


