/*
  deno run --unstable --allow-read --allow-run parse-tsv.js lujvo.json
*/

import { readJson } from "https://deno.land/std/fs/mod.ts";
import { exec, OutputMode } from "https://deno.land/x/exec/mod.ts";

const glosa_mapping = {
    '2nd conversion': '2⇄1',
    '3rd conversion': '3⇄1',
    '4th conversion': '4⇄1',
    '5th conversion': '5⇄1'
};

function map_glosa(glosa) {
    const result = glosa_mapping[glosa];
    if (result !== undefined) {
        return result;
    } else {
        return glosa;
    }
}

async function query_dict(word) {
    const output = await exec('gernytci -f json zvafahi ' + word, {
        output: OutputMode.Capture
    });
    if (output.status.code !== 0) {
        return null;
    }
    const parsedOutput= JSON.parse(output.output);
    if (parsedOutput == undefined) {
        return null;
    }
    for (const match of parsedOutput.zvati.cmene) {
        if (match.cmene === word) {
            return match;
        }
    }
    return null;
}

async function parse_lujvo(lujvo) {
    const output = await exec('gernytci -f json tanru ' + lujvo, {
        output: OutputMode.Capture
    });
    if (output.status.code !== 0) {
        return 'failed to query gernytci';
    }
    const parsedOutput= JSON.parse(output.output);
    if (parsedOutput == undefined) {
        return 'failed to parse output';
    }

    const rafsi = parsedOutput.rafsi.map(x => x.rafsi + (x.terjonlehu || '')).join('·');
    const tanru = parsedOutput.tanru;
    if (tanru.findIndex(x => x === null || x.glosa === null) !== -1) {
        // this is okay
        // return 'failed to find tanru';
    }

    const glosa = tanru.map(x => x === null ? "???" : map_glosa(x.glosa)).join(' + ');
    const tanru_gismu = tanru.map(x => x === null ? "???" : x.cmene).join(' ');
    const lujvo_definition = await query_dict(lujvo);
    if (lujvo_definition === null) {
        return 'failed to lookup definition'
    }

    const lujvo_glosa = lujvo_definition.glosa;
    const lujvo_smuni = lujvo_definition.smuni;

    return {
        lujvo: lujvo,
        rafsi: rafsi,
        tanru: tanru_gismu,
        tanru_glosa: glosa,
        lujvo_glosa: lujvo_glosa,
        lujvo_smuni: lujvo_smuni
    }
}

const lujvo_list = await readJson(Deno.args[0]);
for (const lujvo of lujvo_list) {
    const res = await parse_lujvo(lujvo);

    if (typeof res === 'object' && res.rafsi.length > 0) {
        const fields = [
            res.lujvo,
            res.rafsi,
            res.tanru,
            res.tanru_glosa,
            res.lujvo_glosa,
            res.lujvo_smuni
        ];

        const regularized_fields = fields
              .map(x => x || '')
              .map(x => x.replaceAll("\t", " "));
        console.log(regularized_fields.join("\t"));
    }
}
