
// Plugin "help"

// Dependencies
import path from 'node:path';
import pad from 'pad';
import {clone, is_object_literal, merge} from 'mixme';
import {error, filedirname} from '../utils/index.js';
const {__dirname} = filedirname(import.meta.url);

// Shell.js & plugins
import Shell from '../Shell.js';
import '../plugins/config.js';

Shell.prototype.init = (function(parent) {
  return function() {
    this.register({
      configure_set: function({config, command}, handler) {
        if (command.length) {
          return handler;
        }
        if (config.commands == null) {
          config.commands = {};
        }
        if (!command.length) {
          if (config.description == null) {
            config.description = 'No description yet';
          }
        }
        // No "help" option for command "help"
        if (!command.length || !config.help) {
          if (config.options == null) {
            config.options = {};
          }
          config.options['help'] = merge(config.options['help'], {
            cascade: true,
            shortcut: 'h',
            description: 'Display help information',
            type: 'boolean',
            help: true
          });
        }
        if (!command.length && Object.keys(config.commands).length) {
          command = {
            name: 'help',
            description: "Display help information",
            main: {
              name: 'name',
              description: 'Help about a specific command'
            },
            help: true,
            handler: 'shell/routes/help',
            options: {
              'help': {
                disabled: true
              }
            }
          };
          config.commands[command.name] = merge(command, config.commands[command.name]);
        }
        return function() {
          handler.call(this, ...arguments);
          return config.description != null ? config.description : config.description = `No description yet for the ${config.name} command`;
        };
      }
    });
    this.register({
      configure_set: function({config, command}, handler) {
        if (!command.length) {
          return handler;
        }
        return function() {
          handler.call(this, ...arguments);
          return config.description != null ? config.description : config.description = `No description yet for the ${config.name} command`;
        };
      }
    });
    return parent.call(this, ...arguments);
  };
})(Shell.prototype.init);

// ## Method `helping(params)`

// Determine if help was requested by returning zero to n commands if help is requested or null otherwise.

// * `params` ([object] | object)   
//   The parameter object parsed from arguments, an object in flatten mode or an array in extended mode, optional.
Shell.prototype.helping = function(params, options = {}) {
  params = clone(params);
  const appconfig = this.confx().get();
  let commands;
  if (options.extended == null) {
    options.extended = appconfig.extended;
  }
  if (!options.extended) {
    if (!is_object_literal(params)) {
      throw error(["Invalid Arguments:", "`helping` expect a params object as first argument", "in flatten mode,", `got ${JSON.stringify(params)}`]);
    }
  } else {
    if (!(Array.isArray(params) && !params.some(function(cparams) {
      return !is_object_literal(cparams);
    }))) {
      throw error(["Invalid Arguments:", "`helping` expect a params array with literal objects as first argument", "in extended mode,", `got ${JSON.stringify(params)}`]);
    }
  }
  // Extract the current commands from the arguments
  if (!options.extended) {
    if (params[appconfig.command] && !Array.isArray(params[appconfig.command])) {
      throw error(['Invalid Arguments:', `parameter ${JSON.stringify(appconfig.command)} must be an array in flatten mode,`, `got ${JSON.stringify(params[appconfig.command])}`]);
    }
    // In flatten mode, extract the commands from params
    commands = params[appconfig.command] || [];
  } else {
    commands = params.slice(1).map(function(cparams) {
      return cparams[appconfig.command];
    });
  }
  // Handle help command
  // if this is the help command, transform the leftover into a new command
  if (commands.length && appconfig.commands && appconfig.commands[commands[0]].help) {
    // Note, when argv equals ['help'], there is no leftover and main is null
    const leftover = !options.extended ? params[appconfig.commands[commands[0]].main.name] : params[1][appconfig.commands[commands[0]].main.name];
    if (leftover) {
      return leftover;
    } else {
      return [];
    }
  }
  // Handle help option:
  // search if the help option is provided and for which command it apply
  const search = function(config, commands, params) {
    const cparams = !options.extended ? params : params.shift();
    // Search the help option
    const helping = Object.values(config.options).filter(function(options) {
      return options.help;
    // Check if it is present in the extracted arguments
    }).some(function(options) {
      return cparams[options.name] != null;
    });
    if (helping) {
      if (options.extended && commands.length) {
        throw error(['Invalid Argument:', '`help` must be associated with a leaf command']);
      }
      return true;
    }
    if (!(commands != null ? commands.length : void 0)) {
      // Helping is not requested and there are no more commands to search
      return false;
    }
    const command = commands.shift();
    if (options.extended && params.length === 0) {
      return false;
    }
    config = config.commands[command];
    return search(config, commands, params);
  };
  const helping = search(appconfig, clone(commands), params);
  if (helping) {
    return commands;
  } else {
    return null;
  }
};

// ## Method `help(commands, options)`

// Format the configuration into a readable documentation string.

// * `commands` ([string] | string)   
//   The string or array containing the command name if any, optional.
// * `options.extended` (boolean)   
//   Print the child command descriptions, default is `false`.
// * `options.indent` (string)   
//   Indentation used with output help, default to 2 spaces.
// * `options.columns` (integer|[integer])   
//   The with of a column expressed as the number of characters. The value must
//   equal or exceed 10. If the total column width exists (`process.stdout.columns`
//   with TTY environments), the option one_column is automatically activated if
//   the total width is less than twice this value.

// It returns the formatted help to be printed as a string.
Shell.prototype.help = function(commands = [], options = {}) {
  if (options.indent == null) {
    options.indent = '  ';
  }
  if (options.columns == null) {
    options.columns = 28;
  }
  if (options.columns < 10) {
    throw error(['Invalid Help Column Option:', 'must exceed a size of 10 columns,', `got ${JSON.stringify(options.columns)}`]);
  }
  if (process.stdout.columns == null) {
    if (options.one_column == null) {
      options.one_column = false;
    }
  }
  if (options.one_column == null) {
    options.one_column = process.stdout.columns - options.columns < options.columns;
  }
  if (typeof commands === 'string') {
    commands = commands.split(' ');
  }
  if (!Array.isArray(commands)) {
    throw error(['Invalid Help Arguments:', 'expect commands to be an array as first argument,', `got ${JSON.stringify(commands)}`]);
  }
  const appconfig = this.confx().get();
  let config = appconfig;
  const configs = [config];
  for (const i in commands) {
    const command = commands[i];
    config = config.commands[command];
    if (!config) {
      throw error(['Invalid Command:', `argument \"${commands.slice(0, i + 1).join(' ')}\" is not a valid command`]);
    }
    configs.push(config);
  }
  // Init
  const content = [];
  content.push('');
  // Name
  content.push('NAME');
  const name = configs.map(function(config) {
    return config.name;
  }).join(' ');
  const nameDescription = configs[configs.length - 1].description;
  if (options.one_column) {
    content.push(...[`${name}`, `${nameDescription}`].map(function(l) {
      return `${options.indent}${l}`;
    }));
  } else {
    content.push(`${options.indent}${name} - ${nameDescription}`);
  }
  // Synopsis
  content.push('');
  content.push('SYNOPSIS');
  const synopsis = [];
  for (let i = 0; i < configs.length; i++) {
    const config = configs[i]
    synopsis.push(config.name);
    // Find if there are options other than help
    if (Object.values(config.options).some(function(option) {
      return !option.help;
    })) {
      synopsis.push(`[${config.name} options]`);
    }
    // Is current config
    if (i === configs.length - 1) {
      // There are more subcommand
      if (Object.keys(config.commands).length) {
        synopsis.push(`<${appconfig.command}>`);
      } else if (config.main) {
        synopsis.push(`{${config.main.name}}`);
      }
    }
  }
  content.push(`${options.indent}${synopsis.join(' ')}`);
  // Options
  for (const config of configs.slice(0).reverse()) {
    if (Object.keys(config.options).length || config.main) {
      content.push('');
      if (configs.length === 1) {
        content.push("OPTIONS");
      } else {
        content.push(`OPTIONS for ${config.name}`);
      }
    }
    if (config.main) {
      const description = config.main.description || `No description yet for the ${config.main.name} option.`;
      if (options.one_column) {
        content.push(...[`${config.main.name}`, `${description}`].map(function(l) {
          return `${options.indent}${l}`;
        }));
      } else {
        let line = `${options.indent}   ${config.main.name}`;
        line = pad(line, options.columns);
        if (line.length > options.columns) {
          content.push(line);
          line = ' '.repeat(options.columns);
        }
        line += description;
        content.push(line);
      }
    }
    for (const name of Object.keys(config.options).sort()) {
      const option = config.options[name];
      let description = option.description || `No description yet for the ${option.name} option.`;
      if (option.required) {
        description += ' Required.';
      }
      if (options.one_column) {
        content.push(...[option.shortcut ? `-${option.shortcut}` : void 0, `--${option.name}`, `${description}`].filter(function(l) {
          return l;
        }).map(function(l) {
          return `${options.indent}${l}`;
        }));
      } else {
        const shortcut = option.shortcut ? `-${option.shortcut} ` : '   ';
        let line = `${options.indent}${shortcut}--${option.name}`;
        line = pad(line, options.columns);
        if (line.length > options.columns) {
          content.push(line);
          line = ' '.repeat(options.columns);
        }
        line += description;
        content.push(line);
      }
    }
  }
  // Command
  config = configs[configs.length - 1];
  if (Object.keys(config.commands).length) {
    content.push('');
    content.push('COMMANDS');
    for (const name in config.commands) {
      const command = config.commands[name];
      let line = pad(`${options.indent}${[command.name].join(' ')}`, options.columns);
      if (line.length > options.columns) {
        content.push(line);
        line = ' '.repeat(options.columns);
      }
      line += command.description || `No description yet for the ${command.name} command.`;
      content.push(line);
    }
    // Detailed command information
    if (options.extended) {
      for (const name in config.commands) {
        const command = config.commands[name];
        content.push('');
        content.push(`COMMAND \"${command.name}\"`);
        // Raw command, no main, no child commands
        if (!Object.keys(command.commands).length && !(command.main && command.main.required)) {
          let line = `${command.name}`;
          line = pad(`${options.indent}${line}`, options.columns);
          if (line.length > options.columns) {
            content.push(line);
            line = ' '.repeat(options.columns);
          }
          line += command.description || `No description yet for the ${command.name} command.`;
          content.push(line);
        }
        // Command with main
        if (command.main) {
          let line = `${command.name} {${command.main.name}}`;
          line = pad(`${options.indent}${line}`, options.columns);
          if (line.length > options.columns) {
            content.push(line);
            line = ' '.repeat(options.columns);
          }
          line += command.main.description || `No description yet for the ${command.main.name} option.`;
          content.push(line);
        }
        // Command with child commands
        if (Object.keys(command.commands).length) {
          let line = [`${command.name}`];
          if (Object.keys(command.options).length) {
            line.push(`[${command.name} options]`);
          }
          line.push(`<${command.command}>`);
          content.push(`${options.indent}${line.join(' ')}`);
          commands = Object.keys(command.commands);
          if (commands.length === 1) {
            content.push(`${options.indent}Where command is ${Object.keys(command.commands)}.`);
          } else if (commands.length > 1) {
            content.push(`${options.indent}Where command is one of ${Object.keys(command.commands).join(', ')}.`);
          }
        }
      }
    }
  }
  // Add examples
  config = configs[configs.length - 1];
  // has_help_option = Object.values(config.options).some (option) -> option.name is 'help'
  const has_help_command = Object.values(config.commands).some(function(command) {
    return command.name === 'help';
  });
  const has_help_option = true;
  content.push('');
  content.push('EXAMPLES');
  const cmd = configs.map(function(config) {
    return config.name;
  }).join(' ');
  if (has_help_option) {
    if (options.one_column) {
      content.push(...[`${cmd} --help`, "Show this message"].map(function(l) {
        return `${options.indent}${l}`;
      }));
    } else {
      let line = pad(`${options.indent}${cmd} --help`, options.columns);
      if (line.length > options.columns) {
        content.push(line);
        line = ' '.repeat(options.columns);
      }
      line += 'Show this message';
      content.push(line);
    }
  }
  if (has_help_command) {
    if (options.one_column) {
      content.push(...[`${cmd} help`, "Show this message"].map(function(l) {
        return `${options.indent}${l}`;
      }));
    } else {
      let line = pad(`${options.indent}${cmd} help`, options.columns);
      if (line.length > options.columns) {
        content.push(line);
        line = ' '.repeat(options.columns);
      }
      line += 'Show this message';
      content.push(line);
    }
  }
  content.push('');
  return content.join('\n');
};
