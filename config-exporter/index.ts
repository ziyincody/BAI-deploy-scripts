import * as xlsx from 'node-xlsx';
import * as fs from 'fs';

function transform(data: Record<string, any>) {
    const ds = new Array<(number | string | null)[]>()
    const ranges = new Array<{ s: { c: number, r: number }, e: { c: number, r: number } }>()

    for (const [key, entry] of Object.entries(data)) {
        if (entry instanceof Object) {
            if (entry instanceof Array && entry.length === 0) {
                ds.push([key, '-/-'])
            }
            const inner = transform(entry)
            const currentStart = ds.length;
            const currentEnd = currentStart + inner.ds.length - 1;
            ranges.push({ s: { c: 0, r: currentStart }, e: { c: 0, r: currentEnd } })
            ds.push(...inner.ds.map(x => [key, ...x]))
            ranges.push(...inner.ranges.map(x => ({ s: { c: x.s.c + 1, r: x.s.r + currentStart }, e: { c: x.e.c + 1, r: x.e.r + currentStart } })))
        }
        else {
            ds.push([key, `${entry}`.startsWith('0x') || isNaN(+entry) ? entry : (`${entry}`.includes('.') ? `"${parseFloat(entry)}"` : `"${BigInt(`${entry}`)}"`)])
        }
    }

    return { ds, ranges }
}

(async () => {
    const data = JSON.parse(fs.readFileSync('../config/mumbai.json', 'utf-8'))
    const transformed = transform(data);
    const dataSheet1 = transformed.ds;
    const sheetOptions = { '!merges': transformed.ranges };

    var buffer = xlsx.build([{ name: "myFirstSheet", data: dataSheet1, options: sheetOptions }]); // Returns a buffer

    fs.writeFileSync('out.xlsx', Buffer.from(buffer))

})()