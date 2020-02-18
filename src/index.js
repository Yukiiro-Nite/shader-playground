import ShaderPage from './components/ShaderPage/ShaderPage';

const shaderConfigs = {};
const requireContext = require.context('./shaders', true, /.conf.js$/)
requireContext.keys().forEach((key) => {
  shaderConfigs[key] = requireContext(key).default;
})

const shaderPage = document.createElement('shader-page');

const shaderOptions = Object.entries(shaderConfigs)
  .map(([key, conf]) => ({ label: conf.name, value: key }));
const shaderSelect = createSelect(shaderOptions);
shaderSelect.addEventListener('change', (event) => {
  shaderPage.shaderConfig = shaderConfigs[event.target.value];
});

const container = document.getElementById('container');
container.appendChild(shaderSelect);
container.appendChild(shaderPage);

function createSelect(options) {
  const select = document.createElement('select');
  const defaultOption = document.createElement('option');
  defaultOption.selected = true;
  defaultOption.hidden = true;
  select.appendChild(defaultOption);

  options.forEach((attrs) => {
    const optionEl = document.createElement('option');
    const { label, ...restAttrs } = attrs;
    optionEl.innerHTML = label;
    optionEl.label = label;
    Object.entries(restAttrs).forEach(([key, value]) => {
      optionEl.setAttribute(key, value);
    })

    select.appendChild(optionEl);
  })

  return select;
}