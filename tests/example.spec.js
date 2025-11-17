const { test, expect } = require('@playwright/test');

test('Página abre no Google', async ({ page }) => {
  await page.goto('https://www.google.com');
  await expect(page).toHaveTitle(/Google/);
});
