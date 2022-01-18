
import * as xlsx from 'node-xlsx';
import * as fs from 'fs';

(async () => {
    const data = xlsx.parse('./in.xlsx')[0].data
    let currentScope = Array<string>();
    let objectStack = [{} as Record<string, unknown>];
    for (const row of data) {
        const firstNonUndefinedIndex = row.findIndex(x => x !== undefined);
        const dataRow = row.slice(firstNonUndefinedIndex);
        let dataEnd = dataRow.findIndex(x => x === undefined);
        dataEnd = dataEnd === -1 ? dataRow.length : dataEnd;
        const hasSuffix = [
            'hundreds',
            'seconds',
            'WAD',
            'RAY',
            'RAD',
        ].includes(dataRow[dataEnd - 1] as string)
        objectStack = objectStack.slice(0, 1 + firstNonUndefinedIndex)
        const newScopeSection = dataRow.slice(0, hasSuffix ? dataEnd - 2 : dataEnd - 1)
        for (let i = 0; i < newScopeSection.length; i++) {
            const scopePart = newScopeSection[i]
            objectStack[objectStack.length - 1][isNaN(Number(scopePart)) ? scopePart as string : Number(scopePart)] = isNaN(Number(newScopeSection[i + 1])) ? {} : []
            objectStack.push(objectStack[objectStack.length - 1][isNaN(Number(scopePart)) ? scopePart as string : Number(scopePart)] as Record<string, unknown>)
        }
        if (hasSuffix) {
            objectStack[objectStack.length - 1].value = (dataRow[dataEnd - 2] as string).replace(/"/g, '')
            objectStack[objectStack.length - 1].unit = dataRow[dataEnd - 1]

        } else {
            objectStack.pop()
            const value = dataRow[dataEnd - 1];
            const lastKey = newScopeSection[newScopeSection.length - 1] as string;
            objectStack[objectStack.length - 1][isNaN(Number(lastKey)) ? lastKey as string : Number(lastKey)] = typeof value === 'string' ? value.replace(/"/g, '') : value
        }
        currentScope = [...currentScope.slice(0, firstNonUndefinedIndex), ...newScopeSection] as string[];
    }
    fs.writeFileSync('./config.json', JSON.stringify(objectStack[0]))
})()